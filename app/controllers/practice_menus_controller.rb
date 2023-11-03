class PracticeMenusController < ApplicationController


    def index
        @practice_menus = PracticeMenu.all
    end

    def show 
        @practice_menu = PracticeMenu.find(params[:id])
    end

    def new 
        @practice_menu = PracticeMenu.new
    end

    def create 
        @practice_menu = PracticeMenu.new(practice_menu_params)
        if @practice_menu.save
          flash[:success] = "ゴルフ場作成に成功しました。"
          redirect_to practice_menus_path
        else
          render 'new'
        end
    end

    def edit 
        @practice_menu = PracticeMenu.find(params[:id])
    end

    def update
        @practice_menu = PracticeMenu.find(params[:id])
        if @practice_menu.update(practice_menu_params)
            flash[:success] = "ゴルフ場情報を更新しました。"
            redirect_to practice_menu_path(@practice_menu.id)
        else
            render 'edit'
        end
    end

    def destroy
        @practice_menu = PracticeMenu.find(params[:id])
        @practice_menu.destroy
        redirect_to practice_menus_path, notice: "コースとホールが削除されました。"
    end



    private

    def practice_menu_params
        params.require(:practice_menu).permit(:title, :methods, :objective, :trick, :level, :category, :practice_type)
    end

end