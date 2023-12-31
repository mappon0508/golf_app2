class TopPagesController < ApplicationController
    before_action :logged_in_user, only: [:index, :show, :create]
    before_action :correct_user,   only: [:index, :show, :create]

  def home
  end

  def main
    @user = current_user
    @average_score = @user.average_score
    @week_dates = []
    @practice_days = PracticeDay.get_practice_time_for_week(current_user)
    @practice_schedules = PracticeSchedule.where(practice_day_id: @practice_days)
    @practice_schedules_by_day = @practice_schedules.group_by { |schedule| schedule.practice_day.content }
  end

  def how_to_use  
  end

  def terms_of_use
  end
  



  
end
