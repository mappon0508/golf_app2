# frozen_string_literal: true

class PracticeDay < ApplicationRecord
  has_many :practice_schedules

  validates :practice_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 24 }

  def self.total_practice_time_for_week(user)
    # 今日から1週間分の日付範囲を計算
    start_date = Date.today
    end_date = (start_date + 1.week) - 1

    # ユーザーおよび日付範囲でフィルタリングして練習時間を取得
    practice_days = where(user_id: user.id, content: start_date..end_date)

    # 合計時間を計算（1時間単位で合算）
    practice_days.sum { |day| day.practice_time.to_i }

    # 結果を"HH時間"の形式にフォーマット
  end

  def self.get_practice_time_for_week(user)
    start_date = Date.today
    end_date = (start_date + 1.week) - 1
    where(user_id: user.id, content: start_date..end_date)
  end
end
