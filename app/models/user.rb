# frozen_string_literal: true
module GolfPlayRecordStats
  def calculate_statistic_for_user(statistic_method)
    golf_play_records = self.golf_play_records.where(finish: 'finished')
    statistics = golf_play_records.map(&statistic_method)

    return 0.0 unless statistics.any?

    total_percentage = statistics.sum
    total_percentage / statistics.length
  end
end

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :golf_courses
  has_many :practice_days
  has_many :golf_play_records

  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true,
                    allow_nil: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  validates :birthday, presence: true

  validates :gender, inclusion: { in: %w[man woman other] }
  enum gender: { other: 0, man: 1, woman: 2  }

  validates :golf_experience, numericality: { greater_than_or_equal_to: 0 }

  validates :best_score, numericality: { greater_than_or_equal_to: 18 }

  validates_acceptance_of :agreement, allow_nil: false, on: :create

  validates :very_weak_point,
            inclusion: { in: %w[not tee_shot shot_within_two_hundredone_from_hundred_fifty
                                shot_within_hundred_fifty_from_hundred
                                approach_shot approach bunker long_putt short_putt] }
  enum very_weak_point: { not: 0, tee_shot: 1, shot_within_two_hundredone_from_hundred_fifty: 2,
                          shot_within_hundred_fifty_from_hundred: 3, approach_shot: 4, approach: 5,
                          bunker: 6, long_putt: 7, short_putt: 8 }

  validates :weak_point,
            inclusion: { in: %w[not_weak_point weak_tee_shot weak_shot_within_two_hundredone_from_hundred_fifty
                                weak_shot_within_hundred_fifty_from_hundred weak_approach_shot weak_approach
                                weak_bunker weak_long_putt weak_short_putt] }
  enum weak_point: { not_weak_point: 0, weak_tee_shot: 1, weak_shot_within_two_hundredone_from_hundred_fifty: 2,
                     weak_shot_within_hundred_fifty_from_hundred: 3, weak_approach_shot: 4, weak_approach: 5,
                     weak_bunker: 6, weak_long_putt: 7, weak_short_putt: 8 }

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # フェアウェイキープ率を計算
  def calculate_fairway_keep_percentage_for_user
    calculate_statistic_for_user(:calculate_fairway_keep_percentage)
  end

  # パーオン率を計算
  def calculate_par_on_percentage_for_user
    calculate_statistic_for_user(:calculate_par_on_percentage)
  end

  # 200y~150y以内パーオン率を計算
  def calculate_within_200_to_150_par_on_percentage_for_user
    calculate_statistic_for_user(:calculate_within_200_to_150_par_on_percentage)
  end

  # 150y~100y以内パーオン率を計算
  def calculate_within_150_to_100_par_on_percentage_for_user
    calculate_statistic_for_user(:calculate_within_150_to_100_par_on_percentage)
  end

  # 100y以内2ピン寄せ率を計算
  def calculate_within_100_two_pin_percentage_for_user
    calculate_statistic_for_user(:calculate_within_100_two_pin_percentage)
  end

  # アプローチ成功率を計算
  def calculate_approach_success_rate_for_user
    calculate_statistic_for_user(:calculate_approach_success_rate)
  end

  # サンドセーブ率を計算
  def calculate_bunker_save_rate_for_user
    calculate_statistic_for_user(:calculate_bunker_save_rate)
  end

  # ロングパット成功率を計算
  def calculate_long_putt_success_rate_for_user
    calculate_statistic_for_user(:calculate_long_putt_success_rate)
  end

  # ショートパット成功率を計算
  def calculate_short_putt_success_rate_for_user
    calculate_statistic_for_user(:calculate_short_putt_success_rate)
  end

  def very_weak_point_update
    # 基準値を定義
    criteria = {
      tee_shot: 60,
      shot_within_two_hundredone_from_hundred_fifty: 30,
      shot_within_hundred_fifty_from_hundred: 50,
      approach_shot: 40,
      approach: 70,
      bunker: 50,
      long_putt: 80,
      short_putt: 90
    }

    # カテゴリごとにユーザーの平均値を計算
    category_averages = {
      tee_shot: calculate_fairway_keep_percentage_for_user,
      shot_within_two_hundredone_from_hundred_fifty: calculate_within_200_to_150_par_on_percentage_for_user,
      shot_within_hundred_fifty_from_hundred: calculate_within_150_to_100_par_on_percentage_for_user,
      approach_shot: calculate_within_100_two_pin_percentage_for_user,
      approach: calculate_approach_success_rate_for_user,
      bunker: calculate_bunker_save_rate_for_user,
      long_putt: calculate_long_putt_success_rate_for_user,
      short_putt: calculate_short_putt_success_rate_for_user
    }

    # カテゴリごとに基準値を割った値を計算
    category_ratios = category_averages.transform_values do |average|
      category_name = category_averages.key(average)
      criteria[category_name] / average
    end
    # カテゴリごとにユーザーの基準値を平均値で割った値を降順でソート
    sorted_categories = category_ratios.sort_by { |_category, ratio| -ratio }
    # 最大の2つのカテゴリを選択
    most_important_categories = sorted_categories.reject { |_category, ratio| ratio == Float::INFINITY }.take(1)
    # most_important_categoriesの中身があるか確認
    return if most_important_categories.empty?

    most_important_category = most_important_categories.first.first.to_s
    # ユーザーの very_weak_point カラムを更新
    return unless very_weak_point != most_important_category

    update(very_weak_point: most_important_category)
  end

  def weak_point_update
    # 基準値を定義
    criteria = {
      weak_tee_shot: 53,
      weak_shot_within_two_hundredone_from_hundred_fifty: 30,
      weak_shot_within_hundred_fifty_from_hundred: 50,
      weak_approach_shot: 25,
      weak_approach: 65,
      weak_bunker: 25,
      weak_long_putt: 90,
      weak_short_putt: 60
    }

    # カテゴリごとにユーザーの平均値を計算
    category_averages = {
      weak_tee_shot: calculate_fairway_keep_percentage_for_user,
      weak_shot_within_two_hundredone_from_hundred_fifty: calculate_within_200_to_150_par_on_percentage_for_user,
      weak_shot_within_hundred_fifty_from_hundred: calculate_within_150_to_100_par_on_percentage_for_user,
      weak_approach_shot: calculate_within_100_two_pin_percentage_for_user,
      weak_approach: calculate_approach_success_rate_for_user,
      weak_bunker: calculate_bunker_save_rate_for_user,
      weak_long_putt: calculate_long_putt_success_rate_for_user,
      weak_short_putt: calculate_short_putt_success_rate_for_user
    }

    # カテゴリごとに基準値を割った値を計算
    category_ratios = category_averages.transform_values do |average|
      category_name = category_averages.key(average)
      criteria[category_name] / average
    end
    # カテゴリごとにユーザーの基準値を平均値で割った値を降順でソート
    sorted_categories = category_ratios.sort_by { |_category, ratio| -ratio }
    # 最大の2つのカテゴリを選択
    unless sorted_categories.any? { |_category, ratio| ratio == Float::INFINITY }
      most_important_categories = sorted_categories.reject { |_category, ratio| ratio == Float::INFINITY }.take(2)
    end

    # most_important_categoriesの中身があるか確認
    return if most_important_categories.nil? || most_important_categories.empty?

    most_important_category = most_important_categories.second.first.to_s
    # ユーザーの very_weak_point カラムを更新
    return unless weak_point != most_important_category

    update(weak_point: most_important_category)
  end

  def average_score
    # ユーザに関連付けられたゴルフプレイレコードを取得
    golf_play_records = self.golf_play_records
    total_scores = 0
    total_rounds = 0

    # 各プレイレコードのスコアを取得して合計
    golf_play_records.each do |record|
      if record.finish == 'finished' # プレイが完了したレコードのみ考慮
        total_scores += record.scores.sum(:content)
        total_rounds += 1
      end
    end

    return 0.0 unless total_rounds.positive?

    (total_scores.to_f / total_rounds).round(1) # 小数点第一位まで四捨五入

    # 0.0を返すことで小数点以下がある形にする
  end

  #  ユーザーのベストスコアからレベルを選定
  def level_based_on_best_score
    case best_score
    when (0..72)
      'under_par'
    when (73..75)
      'within_seventy_five'
    when (76..80)
      'within_eighty'
    when (81..85)
      'within_eighty_fiv'
    when (86..90)
      'within_ninety'
    when (91..100)
      'within_hundred'
    else
      'hundred_over'
    end
  end

  private
  
  def calculate_statistic_for_user(statistic_method)
    golf_play_records = self.golf_play_records.where(finish: 'finished')
    statistics = golf_play_records.map(&statistic_method)

    return 0.0 unless statistics.any?

    total_percentage = statistics.sum
    total_percentage / statistics.length
  end
end
