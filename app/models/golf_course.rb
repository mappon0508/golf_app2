# frozen_string_literal: true

class GolfCourse < ApplicationRecord
  has_many :holes, dependent: :destroy
  has_many :golf_play_record, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, length: { maximum: 50 }
end
