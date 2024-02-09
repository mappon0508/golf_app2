# frozen_string_literal: true

# GolfCoursesControllerはホールに関連するアクションを管理するコントローラです。
class PracticeAdvicesController < ApplicationController
  def index
    @practice_day = PracticeDay.find(params[:id])
    @practice_advice = PracticeSchedule.where(practice_day_id: @practice_day.id)
  end

  def show
    @practice_advice = PracticeMenu.find(params[:id])
  end

  def create
    @user = current_user
    @golf_courses = @user.golf_courses
    @holes = @golf_courses.map(&:holes).flatten
    @golf_play_records = GolfPlayRecord.where(golf_course_id: @golf_courses.pluck(:id))
    @scores = @golf_play_records.map(&:scores).flatten
    @weaknesses = []
    @average_score = @user.average_score
    @best_score = @user.best_score

    # 1週間の練習時間を取得
    week_practice_time = PracticeDay.total_practice_time_for_week(current_user)
    # 1週間の練習時間の半分の時間を計算
    weak_point_practice_time = (week_practice_time / 2).to_i

    short_game_time = (week_practice_time * 0.7).round.to_i

    shot_game_time = (week_practice_time * 0.3).round.to_i

    #  ユーザーのベストスコアからレベルを選定
    level = @user.level_based_on_best_score
    # ユーザーの苦手分野をそれに対応する練習メニューに変換
    PracticeMenu.map_weak_point_to_category(@user.weak_point)
    # 一番苦手な分野の練習方法出力
    most_selected_menus = PracticeMenu.generate_weak_point_menus(@user, weak_point_practice_time)
    # 二番目に苦手な分野の練習方法出力
    selected_menus = PracticeMenu.generate_selected_menus(weak_point_practice_time, level)
    # ショートゲーム練習メニューを出力
    short_game_menus = PracticeMenu.generate_short_game_menus(short_game_time)
    # ショットゲーム練習メニューを出力
    shot_game_menus = PracticeMenu.generate_shot_game_menus(shot_game_time)
    # 苦手分野の練習メニュー
    weak_point_menus = most_selected_menus + selected_menus
    # 　通常の練習メニュー
    normal_menus = short_game_menus + shot_game_menus
    # 一週間ぶんの練習時間を取得
    practice_days = PracticeDay.get_practice_time_for_week(current_user)

    practice_days.each do |day|
      PracticeSchedule.where(practice_day_id: day.id).delete_all
      practice_time = day.practice_time.to_i
      practice_time.times do
        next unless weak_point_menus.any?

        random_menu = weak_point_menus.sample
        next unless random_menu

        # random_menuがnilでない場合にのみ処理を実行
        schedule = PracticeSchedule.new
        schedule.practice_day_id = day.id
        schedule.practice_menu_id = random_menu.id
        schedule.save
        weak_point_menus.delete_at(weak_point_menus.index(random_menu))
      end
      practice_time = day.practice_time.to_i
      # それまでに記録されていた練習メニューを削除して、新たに練習メニューを作成する。
      practice_time.times do
        next unless normal_menus.any?

        random_menu = normal_menus.sample
        next unless random_menu

        # random_menuがnilでない場合にのみ処理を実行
        schedule = PracticeSchedule.new
        schedule.practice_day_id = day.id
        schedule.practice_menu_id = random_menu.id
        schedule.save
        normal_menus.delete_at(normal_menus.index(random_menu))
      end
    end

    @practice_schedules = PracticeSchedule.where(practice_day_id: practice_days)

    @practice_schedules_by_day = @practice_schedules.group_by { |schedule| schedule.practice_day.content }

    render 'top_pages/main'
  end
end
