# frozen_string_literal: true

# GolfCoursesControllerはゴルフコースに関連するアクションを管理するコントローラです。
class GolfCoursesController < ApplicationController
  def index
    @golf_courses = current_user.golf_courses.all
  end

  def show
    @golf_course = GolfCourse.find(params[:id])
  end

  def new
    @golf_course = GolfCourse.new
    @user = current_user
  end

  def create
    @user = current_user
    @golf_course = GolfCourse.new(golf_course_params)
    if @golf_course.save
      flash[:notice] = 'ゴルフ場作成に成功しました。'
      redirect_to hole_path(id: @golf_course.id)
    else
      flash.now[:alert] = @golf_course.errors.full_messages.join(', ')
      render new_golf_course_path
    end
  end

  def edit
    @golf_course = GolfCourse.find(params[:id])
  end

  def update
    @golf_course = GolfCourse.find(params[:id])
    if @golf_course.update(golf_course_params)
      flash[:success] = 'ゴルフ場情報を更新しました。'
      redirect_to golf_course_path(@golf_course.id)
    else
      render 'edit'
    end
  end

  def destroy
    @golf_course = GolfCourse.find(params[:id])
    @golf_course.destroy
    redirect_to golf_courses_path, notice: 'コースとホールが削除されました。'
  end

  private

  def golf_course_params
    params.require(:golf_course).permit(:name, :user_id)
  end
end
