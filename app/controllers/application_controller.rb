# frozen_string_literal: true

# ApplicationControllerは全てのコントローラの基底クラスです。
# このクラスには共通のメソッドやヘルパー、モジュールなどが含まれています。
class ApplicationController < ActionController::Base
  include SessionsHelper
  include Devise::Controllers::Helpers
  require 'net/http'
  require 'uri'
  require 'json'
  
  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = 'Please log in.'
    redirect_to root_path, status: :see_other
  end
end
