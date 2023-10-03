class TopPagesController < ApplicationController

  def home
  end

  def main
    @user = User.find_by(id: params[:user_id])
  end

  def how_to_use
  end

  def terms_of_use
  end
  
end
