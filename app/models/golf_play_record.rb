# frozen_string_literal: true

class GolfPlayRecord < ApplicationRecord
  belongs_to :golf_course
  belongs_to :user
  has_many :scores, dependent: :destroy
  has_many :holes, through: :golf_course

  validates :weather, inclusion: { in: %w[sunny cloudy rain snow] }
  enum weather: { sunny: 0, cloudy: 1, rain: 2, snow: 3 }

  validates :finish, inclusion: { in: %w[unfinished finished] }
  enum finish: { unfinished: 0, finished: 1 }

  def update_finish_status
    if scores.count == 18
      update(finish: 1)
    else
      update(finish: 0)
    end
  end

  def update_bestscore(user)
    finished_records = GolfPlayRecord.where(finish: 1)

    scores = finished_records.joins(:scores).group('golf_play_records.id').sum('scores.content')

    best_score = user.best_score
    total_scores = scores.values

    return unless total_scores.any? { |score| score < best_score }

    new_best_score = total_scores.min
    user.update(best_score: new_best_score)
  end

  def calculate_fairway_keep_percentage
    holes_with_tee_shot = scores.reject { |score| score.tee_shot == 'no_tee_shot' }
    fairway_keep_scores = holes_with_tee_shot.select { |score| score.tee_shot == 'fairway_keep' }
    return 0.0 if holes_with_tee_shot.empty? # ゼロ除算を回避

    (fairway_keep_scores.length.to_f / holes_with_tee_shot.length * 100).round(2)
  end

  def calculate_par_on_percentage
    on_green = scores.map { |score| score.content - score.putt }
    par_on_count = 0
    on_green.each_with_index do |on_green_value, index|
      hole = holes[index]
      next if hole.nil? # ホールが見つからない場合はスキップ

      par = case hole.par
            when 'par3' then 1
            when 'par4' then 2
            when 'par5' then 3
            else 0
            end

      par_on_count += 1 if on_green_value <= par
    end

    return 0.0 if on_green.empty?  # ゼロ除算を回避

    (par_on_count.to_f / on_green.length * 100).round(2)
  end

  def calculate_within_200_to_150_par_on_percentage
    within_200_to_150_scores = scores.select do |score|
      score.second_shot_distance == 'shot_within_two_hundredone_from_hundred_fifty'
    end
    on_green = within_200_to_150_scores.map { |score| score.content - score.putt }
    par_on_count = 0

    on_green.each_with_index do |on_green_value, index|
      hole = holes[index]
      next if hole.nil?

      par = case hole.par
            when 'par3' then 1
            when 'par4' then 2
            when 'par5' then 3
            else 0
            end

      par_on_count += 1 if on_green_value <= par
    end

    return 0.0 if on_green.empty?  # ゼロ除算を回避

    (par_on_count.to_f / on_green.length * 100).round(2)
  end

  def calculate_within_150_to_100_par_on_percentage
    within_150_to_100_scores = scores.select do |score|
      score.second_shot_distance == 'shot_within_hundred_fifty_from_hundred'
    end
    on_green = within_150_to_100_scores.map { |score| score.content - score.putt }
    par_on_count = 0

    on_green.each_with_index do |on_green_value, index|
      hole = holes[index]
      next if hole.nil?

      par = case hole.par
            when 'par3' then 1
            when 'par4' then 2
            when 'par5' then 3
            else 0
            end

      par_on_count += 1 if on_green_value <= par
    end

    return 0.0 if on_green.empty?  # ゼロ除算を回避

    (par_on_count.to_f / on_green.length * 100).round(2)
  end

  def calculate_within_100_two_pin_percentage
    within_100_scores = scores.reject { |score| score.approach_shot == 'no_approach_shot' }
    two_pin_scores = within_100_scores.select { |score| score.approach_shot == 'pulled_it_nside_the_two_pin' }
    return 0.0 if within_100_scores.empty? # ゼロ除算を回避

    (two_pin_scores.length.to_f / within_100_scores.length * 100).round(2)
  end

  def calculate_approach_success_rate
    holes_with_approach = scores.reject { |score| score.approach == 'no_approach' }
    approach_success = holes_with_approach.select { |score| score.approach == 'successful_approach' }
    return 0.0 if holes_with_approach.empty? # ゼロ除算を回避

    (approach_success.length.to_f / holes_with_approach.length * 100).round(2)
  end

  def calculate_bunker_save_rate
    holes_with_bunker = scores.reject { |score| score.bunker_save == 'no_bunker' }
    bunker_success = holes_with_bunker.select { |score| score.bunker_save == 'bunker_save_successfully' }
    return 0.0 if holes_with_bunker.empty? # ゼロ除算を回避

    (bunker_success.length.to_f / holes_with_bunker.length * 100).round(2)
  end

  def calculate_three_putt_percentage
    three_putts = scores.select { |score| score.putt >= 3 }
    return 0.0 if scores.empty? # ゼロ除算を回避

    (three_putts.length.to_f / scores.length * 100).round(2)
  end

  def calculate_long_putt_success_rate
    holes_with_long_putt = scores.reject { |score| score.long_putt == 'no_long_putt' }
    long_putt_success = holes_with_long_putt.select { |score| score.long_putt == 'long_putt_successfully' }
    return 0.0 if holes_with_long_putt.empty? # ゼロ除算を回避

    (long_putt_success.length.to_f / holes_with_long_putt.length * 100).round(2)
  end

  def calculate_short_putt_success_rate
    holes_with_short_putt = scores.reject { |score| score.short_putt == 'no_short_putt' }
    short_putt_success = holes_with_short_putt.select { |score| score.short_putt == 'short_putt_successfully' }
    return 0.0 if holes_with_short_putt.empty?  # ゼロ除算を回避

    (short_putt_success.length.to_f / holes_with_short_putt.length * 100).round(2)
  end
end
