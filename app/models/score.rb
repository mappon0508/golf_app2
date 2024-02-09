# frozen_string_literal: true

class Score < ApplicationRecord
  belongs_to :golf_play_record
  belongs_to :hole

  validates_uniqueness_of :hole_id, scope: :golf_play_record_id

  validates :tee_shot, inclusion: { in: %w[no_tee_shot fairway_keep removed_to_the_left removed_to_the_right] }
  enum tee_shot: { no_tee_shot: 0, fairway_keep: 1, removed_to_the_left: 2, removed_to_the_right: 3 }

  validates :second_shot_distance,
            inclusion: { in: %w[no_shot two_hundred_shot_over shot_within_two_hundredone_from_hundred_fifty
                                shot_within_hundred_fifty_from_hundred within_hundred_yard] }
  enum second_shot_distance: { no_shot: 0, two_hundred_shot_over: 1, shot_within_two_hundredone_from_hundred_fifty: 2,
                               shot_within_hundred_fifty_from_hundred: 3, within_hundred_yard: 4 }

  validates :approach_shot,
            inclusion: { in: %w[no_approach_shot pulled_it_nside_the_two_pin on_the_green missed_the_green] }
  enum approach_shot: { no_approach_shot: 0, pulled_it_nside_the_two_pin: 1, on_the_green: 2, missed_the_green: 3 }

  validates :approach, inclusion: { in: %w[no_approach successful_approach approach_failure] }
  enum approach: { no_approach: 0, successful_approach: 1, approach_failure: 2 }

  validates :bunker_save, inclusion: { in: %w[no_bunker bunker_save_successfully bunker_save_failure] }
  enum bunker_save: { no_bunker: 0, bunker_save_successfully: 1, bunker_save_failure: 2 }

  validates :long_putt, inclusion: { in: %w[no_long_putt long_putt_successfully long_putt_failure] }
  enum long_putt: { no_long_putt: 0, long_putt_successfully: 1, long_putt_failure: 2 }

  validates :short_putt, inclusion: { in: %w[no_short_putt short_putt_successfully short_putt_failure] }
  enum short_putt: { no_short_putt: 0, short_putt_successfully: 1, short_putt_failure: 2 }
end
