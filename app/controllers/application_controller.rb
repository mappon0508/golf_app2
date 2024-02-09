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
    binding.pry
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
