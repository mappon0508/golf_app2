# frozen_string_literal: true

# GolfCoursesControllerはホールに関連するアクションを管理するコントローラです。
class HolesController < ApplicationController
  before_action :logged_in_user
  def new
    @golf_course = GolfCourse.find(params[:id])
    @holes = Array.new(18) { Hole.new }
  end

  def create
    @golf_course = GolfCourse.find(params[:holes].first['golf_course_id']) # ゴルフコースのidを取得
    @holes = []

    params[:holes].each do |hole_params|
      @holes << Hole.new(hole_params.permit(:golf_course_id, :number, :par))
    end

    if @holes.all?(&:valid?)
      @holes.each { |hole| @golf_course.holes << hole }

      if @golf_course.save
        flash[:notice] = 'ホールの作成に成功しました。'
        redirect_to golf_course_path(@golf_course.id)
      else
        redireco_to golf_course_path(@golf_course.id)
      end
    else
      flash.now[:alert] = 'ホールの作成に失敗しました。'
      render 'new'
    end
  end

  def edit
    @golf_course = GolfCourse.find(params[:golf_course_id])
    @holes = Hole.where(golf_course_id: params[:golf_course_id])
  end

  def update
    @golf_course = GolfCourse.find(params[:golf_course_id])

    holes_params.each do |hole_param|
      hole = Hole.find_by(golf_course_id: hole_param[:golf_course_id], number: hole_param[:number])
      if hole&.update(hole_param)
        flash[:notice] = 'ホールの編集に成功しました。'
      else
        flash.now[:alert] = 'ホールの編集に失敗しました。'
        render 'edit'
      end
    end
    redirect_to golf_course_path(@golf_course.id)
  end

  private

  def holes_params
    params.require(:holes).map do |hole_params|
      hole_params.permit(:golf_course_id, :number, :par)
    end
  end
end
