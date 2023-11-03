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
        @holes = @golf_courses.map { |course| course.holes }.flatten
        @golf_play_records = GolfPlayRecord.where(golf_course_id: @golf_courses.pluck(:id))
        @scores = @golf_play_records.map { |record| record.scores }.flatten
        @weaknesses = []
        @average_score = @user.average_score
      
        @best_score = @user.best_score

        
        # 1週間の練習時間を取得
        week_practice_time = PracticeDay.total_practice_time_for_week(current_user)
        # 1週間の練習時間の半分の時間を計算
        weak_point_practice_time = (week_practice_time / 2).to_i

        short_game_time = (week_practice_time * 0.7).round.to_i

        shot_game_time = (week_practice_time * 0.3).round.to_i

        most_selected_menus = []
        selected_menus = []
        short_game_menus = []
        shot_game_menus = []

        
        if @user.best_score <= 72
            level = 'under_par'
          elsif @user.best_score <= 75
            level = 'within_seventy_five'
          elsif @user.best_score <= 80
            level = 'within_eighty'
          elsif @user.best_score <= 85
            level = 'within_eighty_fiv'
          elsif @user.best_score <= 90
            level = 'within_ninety'
          elsif @user.best_score <= 100
            level = 'within_hundred'
          else
            level = 'hundred_over'
        end
        # 一番苦手な分野の練習方法出力
        if %w(tee_shot shot_within_two_hundredone_from_hundred_fifty shot_within_hundred_fifty_from_hundred approach_shot approach bunker long_putt short_putt).include?(@user.very_weak_point)
          weak_point_practice_time.times do
            random_menu = PracticeMenu.where(level: level, category: @user.very_weak_point).sample
            most_selected_menus << random_menu
          end
        else
          # best_scoreとvery_weak_pointに合致する条件がない場合の処理
        end

        if @user.weak_point == "weak_tee_shot"
            category = 'tee_shot'
          elsif @user.weak_point == "weak_shot_within_two_hundredone_from_hundred_fifty"
            category = 'shot_within_two_hundredone_from_hundred_fifty'
          elsif @user.weak_point == "weak_shot_within_hundred_fifty_from_hundred"
            category = 'shot_within_hundred_fifty_from_hundred'
          elsif @user.weak_point == "weak_approach_shot"
            category = 'approach_shot'
          elsif @user.weak_point == "weak_approach"
            category = 'approach'
          elsif @user.weak_point == "weak_bunker"
            category = 'bunker'
          elsif @user.weak_point == "weak_long_putt"
            category = 'long_putt'
          else
            category = 'short_putt'
        end
       # 二番目に苦手な分野の練習方法出力
        weak_point_practice_time.times do
          random_menu = PracticeMenu.where(level: level, category: category).sample
          selected_menus << random_menu
        end
       # ショートゲーム練習メニューを出力
        short_game_time.times do
            random_menu = PracticeMenu.where(practice_type: "short_game").sample
            short_game_menus << random_menu
        end
       # ショットゲーム練習メニューを出力
        shot_game_time.times do
            random_menu = PracticeMenu.where(practice_type: "shot_game").sample
            shot_game_menus << random_menu
        end
       # 苦手分野の練習メニュー
        weak_point_menus = most_selected_menus + selected_menus
        #　通常の練習メニュー
        normal_menus = short_game_menus + shot_game_menus
        # 一週間ぶんの練習時間を取得
        practice_days = PracticeDay.get_practice_time_for_week(current_user)

        practice_days.each do |day|
            PracticeSchedule.where(practice_day_id: day.id).delete_all
        end
        

        practice_days.each do |day|
            practice_time = day.practice_time.to_i        
            practice_time.times do
              if weak_point_menus.any?
                random_menu = weak_point_menus.sample
                if random_menu
                  # random_menuがnilでない場合にのみ処理を実行
                  schedule = PracticeSchedule.new
                  schedule.practice_day_id = day.id
                  schedule.practice_menu_id = random_menu.id
                  schedule.save
                  weak_point_menus.delete_at(weak_point_menus.index(random_menu))
                end
              end
            end
        end

        practice_days.each do |day|
            practice_time = day.practice_time.to_i
          
            practice_time.times do
              if normal_menus.any?
                random_menu = normal_menus.sample
                if random_menu
                  # random_menuがnilでない場合にのみ処理を実行
                  schedule = PracticeSchedule.new
                  schedule.practice_day_id = day.id
                  schedule.practice_menu_id = random_menu.id
                  schedule.save
                  normal_menus.delete_at(normal_menus.index(random_menu))
                end
              end
            end
        end

        @practice_schedules = PracticeSchedule.where(practice_day_id: practice_days)

        @practice_schedules_by_day = @practice_schedules.group_by { |schedule| schedule.practice_day.content }


        
        render 'top_pages/main'
      end

      
end
