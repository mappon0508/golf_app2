# frozen_string_literal: true

class PracticeMenu < ApplicationRecord
  has_many :practice_schedules

  validates :level,
            inclusion: { in: %w[hundred_over within_hundred within_ninety within_eighty_fiv
                                within_eighty within_seventy_five under_par] }
  enum level: { hundred_over: 0, within_hundred: 1, within_ninety: 2, within_eighty_fiv: 3, within_eighty: 4,
                within_seventy_five: 5, under_par: 6 }

  validates :category,
            inclusion: { in: %w[tee_shot shot_within_two_hundredone_from_hundred_fifty
                                shot_within_hundred_fifty_from_hundred
                                approach_shot approach bunker long_putt
                                short_putt] }
  enum category: { tee_shot: 0, shot_within_two_hundredone_from_hundred_fifty: 1,
                   shot_within_hundred_fifty_from_hundred: 2, approach_shot: 3,
                   approach: 4, bunker: 5, long_putt: 6, short_putt: 7 }

  validates :practice_type, inclusion: { in: %w[short_game shot_game] }
  enum practice_type: { short_game: 0, shot_game: 1 }

  # 一番苦手な分野の練習方法出力
  def self.generate_weak_point_menus(user, weak_point_practice_time)
    weak_point_menus = []

    if %w[tee_shot shot_within_two_hundredone_from_hundred_fifty shot_within_hundred_fifty_from_hundred
          approach_shot approach bunker long_putt short_putt].include?(user.very_weak_point)
      weak_point_practice_time.times do
        random_menu = PracticeMenu.where(level: user.level_based_on_best_score, category: user.very_weak_point).sample
        weak_point_menus << random_menu
      end
    end

    weak_point_menus
  end

  # 二番目に苦手な分野の練習方法出力
  def self.generate_selected_menus(weak_point_practice_time, level)
    selected_menus = []

    weak_point_practice_time.times do
      random_menu = PracticeMenu.where(level:).sample
      selected_menus << random_menu
    end

    selected_menus
  end

  # ショートゲーム練習メニューを出力
  def self.generate_short_game_menus(short_game_time)
    short_game_menus = []

    short_game_time.times do
      random_menu = PracticeMenu.where(practice_type: 'short_game').sample
      short_game_menus << random_menu
    end

    short_game_menus
  end

  # ショットゲーム練習メニューを出力
  def self.generate_shot_game_menus(shot_game_time)
    shot_game_menus = []

    shot_game_time.times do
      random_menu = PracticeMenu.where(practice_type: 'shot_game').sample
      shot_game_menus << random_menu
    end

    shot_game_menus
  end

  def self.map_weak_point_to_category(weak_point)
    case weak_point
    when 'weak_tee_shot'
      'tee_shot'
    when 'weak_shot_within_two_hundredone_from_hundred_fifty'
      'shot_within_two_hundredone_from_hundred_fifty'
    when 'weak_shot_within_hundred_fifty_from_hundred'
      'shot_within_hundred_fifty_from_hundred'
    when 'weak_approach_shot'
      'approach_shot'
    when 'weak_approach'
      'approach'
    when 'weak_bunker'
      'bunker'
    when 'weak_long_putt'
      'long_putt'
    else
      'short_putt'
    end
  end
end
