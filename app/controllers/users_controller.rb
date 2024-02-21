# frozen_string_literal: true

# GolfCoursesControllerはユーザーに関連するアクションを管理するコントローラです。
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update destroy]
  before_action :correct_user,   only: %i[edit update]

  def show
    @user = User.friendly.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:notice] = 'アカウント作成に成功しました！'
      redirect_to main_top_pages_path
    else
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render 'new'
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to main_top_pages_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def edit_password
    @user = User.friendly.find(params[:id])
  end

  def update_password
    @user = User.friendly.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to main_top_pages_path
    else
      render 'edit_password', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :gender, :golf_experience, :best_score,
                                 :birthday, :agreement, :very_weak_point, :weak_point)
  end


  def correct_user
    @user = User.friendly.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end
end
