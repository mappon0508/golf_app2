class PastScoresController < ApplicationController

    def index
      @golf_courses = current_user.golf_courses.all
      @golf_play_records = GolfPlayRecord.where(golf_course_id: @golf_courses.pluck(:id))
      @scores = Score.where(golf_play_record_id: @golf_play_records.pluck(:id))
      user = current_user
  
      # 全てのフェアウェイキープ率
      @all_fairway_keep_percentage = user.calculate_fairway_keep_percentage_for_user
      
      # 全てのパーオン率
      @all_par_on_percentage = user.calculate_par_on_percentage_for_user
  
      # 全ての200y~150y以内パーオン率
      @all_within_200_to_150_par_on_percentage = user.calculate_within_200_to_150_par_on_percentage_for_user
  
      # 全ての150y~100y以内パーオン率
      @all_within_150_to_100_par_on_percentage = user.calculate_within_150_to_100_par_on_percentage_for_user
  
      # 全ての100y以内2ピン寄せ率
      @all_within_100_two_pin_percentage = user.calculate_within_100_two_pin_percentage_for_user
  
      # 全てのアプローチ成功率
      @all_approach_success_rate = user.calculate_approach_success_rate_for_user
  
      # 全てのサンドセーブ率
      @all_bunker_save_rate = user.calculate_bunker_save_rate_for_user
  
      # 全てのロングパット成功率
      @all_long_putt_success_rate = user.calculate_long_putt_success_rate_for_user
  
      # 全てのショートパット成功率
      @all_short_putt_success_rate = user.calculate_short_putt_success_rate_for_user

    end
end
  