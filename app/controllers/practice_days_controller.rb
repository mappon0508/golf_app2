class PracticeDaysController < ApplicationController


    def new
    @user = current_user
    @holes = Array.new(7) { PracticeDay.new }
    end

    def create
        @user = User.find(params[:practice_days].first["user_id"]) # ユーザーを見つける
      
        practice_day_params.each do |day_params|
          practice_day = PracticeDay.find_or_initialize_by(user_id: day_params[:user_id], content: day_params[:content])
      
          if practice_day.new_record?
            practice_day.assign_attributes(day_params.permit(:user_id, :content, :practice_time))
          else
            practice_day.update(day_params.permit(:practice_time))
          end
      
          unless practice_day.save
            flash.now[:alert] = practice_day.errors.full_messages.join(", ")
            render 'new'
            return
          end
        end
      
        flash[:notice] = "練習アドバイスを作成しました"
        redirect_to practice_advice_path
    end
      
      
      

    private

    def practice_day_params
        params.require(:practice_days).map do |practice_day_params|
            practice_day_params.permit(:user_id, :content, :practice_time)
        end
    end  
end
    