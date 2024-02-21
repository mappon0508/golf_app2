# frozen_string_literal: true

# GolfCoursesControllerは練習スケージュールに関連するアクションを管理するコントローラです。
class PracticeDaysController < ApplicationController
  before_action :logged_in_user
  def new
    @user = current_user
    @holes = Array.new(7) { PracticeDay.new }
  end

  def create
    @user = User.find(params[:practice_days].first['user_id']) # ユーザーを見つける

    practice_day_params.each do |day_params|
      practice_day = PracticeDay.find_or_initialize_by(user_id: day_params[:user_id], content: day_params[:content])

      if practice_day.new_record?
        practice_day.assign_attributes(day_params.permit(:user_id, :content, :practice_time))
      else
        practice_day.update(day_params.permit(:practice_time))
      end

      next if practice_day.save

      flash.now[:alert] = practice_day.errors.full_messages.join(', ')
      render 'new'
    end

    flash[:notice] = '練習アドバイスを作成しました'
    redirect_to practice_advices_path
  end

  private

  def practice_day_params
    params.require(:practice_days).map do |practice_day_params|
      practice_day_params.permit(:user_id, :content, :practice_time)
    end
  end
end
