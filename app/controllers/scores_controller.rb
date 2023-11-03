class ScoresController < ApplicationController


  def index
    @golf_play_record = GolfPlayRecord.find(params[:id])
    @golf_course = @golf_play_record.golf_course
    @holes = @golf_course.holes
    @scores = @golf_play_record.scores

   #フェアウェイキープ率
   @percentage_of_fairways_kept = @golf_play_record.calculate_fairway_keep_percentage
    # パーオン率
    @par_on_percentage = @golf_play_record.calculate_par_on_percentage
    # 200y~150y以内パーオン率
    @within_200_to_150_par_on_percentage = @golf_play_record.calculate_within_200_to_150_par_on_percentage
    #150y~100y以内パーオン率
    @within_150_to_100_par_on_percentage = @golf_play_record.calculate_within_150_to_100_par_on_percentage
    #100y以内2ピン寄せ率
    @within_100_two_pin_percentage = @golf_play_record.calculate_within_100_two_pin_percentage
    #アプローチ成功率
    @approach_success_rate = @golf_play_record.calculate_approach_success_rate
    #サンドセーブ率
    @bunker_save_rate = @golf_play_record.calculate_bunker_save_rate
    #3パット率
    @three_putt_rate = @golf_play_record.calculate_three_putt_percentage
    #ロングパット成功率
    @long_putt_success_rate = @golf_play_record.calculate_long_putt_success_rate
    #ショートパット成功率
    @short_putt_success_rate = @golf_play_record.calculate_short_putt_success_rate


  end
  

    def new
        @golf_play_record = GolfPlayRecord.find(params[:id])
        @golf_course = @golf_play_record.golf_course
        @holes = @golf_course.holes
        @hole = @holes.min_by(&:number)

        @score = Score.new
    end

    def next_new
        @golf_play_record = GolfPlayRecord.find(params[:id])
        @golf_course = @golf_play_record.golf_course
        @holes = @golf_course.holes
        @hole = Hole.find_by(id: params[:hole_id])

        @score = Score.new
    end

    def create
        @score = Score.new(score_params)
      
        existing_score = Score.find_by(golf_play_record_id: @score.golf_play_record_id, hole_id: @score.hole_id)
      
        if existing_score
          # すでにスコアが存在する場合、更新を行う
          existing_score.update(score_params)
        else
          if @score.save
            # スコアが新規に保存された場合
          else
            render 'new'
            return
          end
        end
      
        # スコアの保存または更新後、ラウンド終了ステータスを更新
        @golf_play_record = GolfPlayRecord.find(@score.golf_play_record_id)
        @golf_play_record.update_finish_status
        @golf_play_record.update_bestscore(current_user)
        @golf_play_record.user.very_weak_point_update
        @golf_play_record.user.weak_point_update

      
        @hole_number = Hole.find_by(id: @score.hole_id).number
        if @hole_number == 18
          # 18番ホールの場合、ラウンド終了へ遷移
          redirect_to scores_path(id: @score.golf_play_record_id)
        else
          next_hole_id = (@score.hole_id + 1)
          redirect_to new_scores_path(id: @score.golf_play_record_id, hole_id: next_hole_id)
        end
    end
       

    private

    def score_params
        params.require(:score).permit(:content, :tee_shot, :second_shot_distance, :approach_shot, :approach, :bunker_save, :long_putt, :short_putt, :golf_play_record_id, :hole_id, :putt)
    end

end
