class User < ApplicationRecord
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
    
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    validates :birthday, presence: true

    validates :gender, inclusion: { in: %w(man woman other) }
    enum gender: { other: 0, man: 1, woman: 2,}

    validates :golf_experience, numericality: { greater_than_or_equal_to: 0 }

    validates :best_score, numericality: { greater_than_or_equal_to: 18 }

    validates_acceptance_of :agreement, allow_nil: false, on: :create

    validates :very_weak_point, inclusion: { in: %w(not tee_shot shot_within_two_hundredone_from_hundred_fifty shot_within_hundred_fifty_from_hundred approach_shot approach bunker long_putt short_putt) }
    enum very_weak_point: { not: 0, tee_shot: 1, shot_within_two_hundredone_from_hundred_fifty: 2, shot_within_hundred_fifty_from_hundred: 3, approach_shot: 4, approach: 5, bunker: 6, long_putt: 7, short_putt: 8,}

    validates :weak_point, inclusion: { in: %w(not_weak_point weak_tee_shot weak_shot_within_two_hundredone_from_hundred_fifty weak_shot_within_hundred_fifty_from_hundred weak_approach_shot weak_approach weak_bunker  weak_long_putt weak_short_putt) }
    enum weak_point: { not_weak_point: 0, weak_tee_shot: 1, weak_shot_within_two_hundredone_from_hundred_fifty: 2, weak_shot_within_hundred_fifty_from_hundred: 3, weak_approach_shot: 4, weak_approach: 5, weak_bunker: 6, weak_long_putt: 7, weak_short_putt: 8,}

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    # ランダムなトークンを返す
    def User.new_token
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
      golf_play_records = self.golf_play_records.where(finish: "finished")
      fairway_keep_percentages = golf_play_records.map do |record|
        record.calculate_fairway_keep_percentage
      end
  
      if fairway_keep_percentages.any?
        total_percentage = fairway_keep_percentages.sum
        average_percentage = total_percentage / fairway_keep_percentages.length
        return average_percentage
      else
        return 0.0
      end
    end

    #パーオン率を計算
    def calculate_par_on_percentage_for_user
      golf_play_records = self.golf_play_records.where(finish: "finished")
      par_on_percentages = golf_play_records.map do |record|
        record.calculate_par_on_percentage
      end
  
      if par_on_percentages.any?
        total_percentage = par_on_percentages.sum
        average_percentage = total_percentage / par_on_percentages.length
        return average_percentage
      else
        return 0.0
      end
    end

    # 200y~150y以内パーオン率を計算
  def calculate_within_200_to_150_par_on_percentage_for_user
    golf_play_records = self.golf_play_records.where(finish: "finished")
    par_on_percentages = golf_play_records.map do |record|
      record.calculate_within_200_to_150_par_on_percentage
    end

    if par_on_percentages.any?
      total_percentage = par_on_percentages.sum
      average_percentage = total_percentage / par_on_percentages.length
      return average_percentage
    else
      return 0.0
    end
  end

  # 150y~100y以内パーオン率を計算
  def calculate_within_150_to_100_par_on_percentage_for_user
    golf_play_records = self.golf_play_records.where(finish: "finished")
    par_on_percentages = golf_play_records.map do |record|
      record.calculate_within_150_to_100_par_on_percentage
    end

    if par_on_percentages.any?
      total_percentage = par_on_percentages.sum
      average_percentage = total_percentage / par_on_percentages.length
      return average_percentage
    else
      return 0.0
    end
  end

  # 100y以内2ピン寄せ率を計算
  def calculate_within_100_two_pin_percentage_for_user
    golf_play_records = self.golf_play_records.where(finish: "finished")
    two_pin_percentages = golf_play_records.map do |record|
      record.calculate_within_100_two_pin_percentage
    end

    if two_pin_percentages.any?
      total_percentage = two_pin_percentages.sum
      average_percentage = total_percentage / two_pin_percentages.length
      return average_percentage
    else
      return 0.0
    end
  end

  # アプローチ成功率を計算
  def calculate_approach_success_rate_for_user
    golf_play_records = self.golf_play_records.where(finish: "finished")
    approach_success_rates = golf_play_records.map do |record|
      record.calculate_approach_success_rate
    end

    if approach_success_rates.any?
      total_percentage = approach_success_rates.sum
      average_percentage = total_percentage / approach_success_rates.length
      return average_percentage
    else
      return 0.0
    end
  end

  # サンドセーブ率を計算
  def calculate_bunker_save_rate_for_user
    golf_play_records = self.golf_play_records.where(finish: "finished")
    bunker_save_rates = golf_play_records.map do |record|
      record.calculate_bunker_save_rate
    end

    if bunker_save_rates.any?
      total_percentage = bunker_save_rates.sum
      average_percentage = total_percentage / bunker_save_rates.length
      return average_percentage
    else
      return 0.0
    end
  end

  # ロングパット成功率を計算
  def calculate_long_putt_success_rate_for_user
    golf_play_records = self.golf_play_records.where(finish: "finished")
    long_putt_success_rates = golf_play_records.map do |record|
      record.calculate_long_putt_success_rate
    end

    if long_putt_success_rates.any?
      total_percentage = long_putt_success_rates.sum
      average_percentage = total_percentage / long_putt_success_rates.length
      return average_percentage
    else
      return 0.0
    end
  end

  # ショートパット成功率を計算
  def calculate_short_putt_success_rate_for_user
    golf_play_records = self.golf_play_records.where(finish: "finished")
    short_putt_success_rates = golf_play_records.map do |record|
      record.calculate_short_putt_success_rate
    end

    if short_putt_success_rates.any?
      total_percentage = short_putt_success_rates.sum
      average_percentage = total_percentage / short_putt_success_rates.length
      return average_percentage
    else
      return 0.0
    end
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
    sorted_categories = category_ratios.sort_by { |category, ratio| -ratio }
    # 最大の2つのカテゴリを選択
    most_important_categories = sorted_categories.reject { |category, ratio| ratio == Float::INFINITY }.take(1)
    # most_important_categoriesの中身があるか確認
    unless most_important_categories.empty?
      most_important_category = most_important_categories.first.first.to_s
      # ユーザーの very_weak_point カラムを更新
      if self.very_weak_point != most_important_category
        self.update(very_weak_point: most_important_category)
      end
    end
  end

  def weak_point_update
    # 基準値を定義
    criteria = {
      weak_tee_shot: 60,
      weak_shot_within_two_hundredone_from_hundred_fifty: 30,
      weak_shot_within_hundred_fifty_from_hundred: 50,
      weak_approach_shot: 40,
      weak_approach: 70,
      weak_bunker: 50,
      weak_long_putt: 80,
      weak_short_putt: 90
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
    sorted_categories = category_ratios.sort_by { |category, ratio| -ratio }
    # 最大の2つのカテゴリを選択
    most_important_categories = sorted_categories.reject { |category, ratio| ratio == Float::INFINITY }.take(2)
    # most_important_categoriesの中身があるか確認
    unless most_important_categories.empty?
      most_important_category = most_important_categories.second.first.to_s
      # ユーザーの very_weak_point カラムを更新
      if self.weak_point != most_important_category
        self.update(weak_point: most_important_category)
      end
    end
  end

end
  