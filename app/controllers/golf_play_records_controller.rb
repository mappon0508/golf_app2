# frozen_string_literal: true

# GolfCoursesControllerはゴルフプレイ情報に関連するアクションを管理するコントローラです。
class GolfPlayRecordsController < ApplicationController
  before_action :logged_in_user
  def new
    @user = current_user
    @golf_course = GolfCourse.find(params[:id])
    @golf_play_record = GolfPlayRecord.new
  end

  def create
    @golf_play_record = GolfPlayRecord.new(golf_play_record_params)
    if @golf_play_record.save
      redirect_to score_path(@golf_play_record.id)
    else
      render 'new'
    end
  end

  def edit
    @golf_course = GolfCourse.find(params[:id])
    @golf_play_record = GolfPlayRecord.find(params[:id])
  end

  def update
    @golf_play_record = GolfPlayRecord.find(params[:id])

    if @golf_play_record.update(golf_play_record_params)
      redirect_to score_path(@golf_play_record.id)
    else
      render 'edit'
    end
  end

  private

  def golf_play_record_params
    params.require(:golf_play_record).permit(:golf_course_id, :play_day, :weather, :finish, :user_id)
  end
end
