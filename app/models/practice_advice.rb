# frozen_string_literal: true

class PracticeAdvice < ApplicationRecord
  belongs_to :user
  belongs_to :golf_course
end
