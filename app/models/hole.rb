# frozen_string_literal: true

class Hole < ApplicationRecord
  belongs_to :golf_course
  has_many :scores, dependent: :destroy

  validates_uniqueness_of :number, scope: :golf_course_id
  validates :number, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 18 }

  validates :par, inclusion: { in: %w[par4 par3 par5] }
  enum par: { par4: 0, par3: 1, par5: 2 }
end
