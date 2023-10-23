class TopPagesController < ApplicationController

  def home
  end

  def main
    @user = current_user
    @average_score = average_score(current_user)
    @week_dates = []
    @practice_days = PracticeDay.get_practice_time_for_week(current_user)
    @practice_schedules = PracticeSchedule.where(practice_day_id: @practice_days)
    @practice_schedules_by_day = @practice_schedules.group_by { |schedule| schedule.practice_day.content }
  end

  def how_to_use
  end

  def terms_of_use
  end
  
  def average_score(user)
    # finishカラムが1のレコードを取得
    finished_records = GolfPlayRecord.where(finish: 1)
  
    scores = finished_records.joins(:scores).group('golf_play_records.id').sum('scores.content')
  
    if scores.any?
      total_scores = scores.values
      average_score = total_scores.sum / total_scores.size.to_f
      return average_score
    else
      return "スコアがありません"
    end
  end

  
end
