# frozen_string_literal: true

class PracticeSchedule < ApplicationRecord
  belongs_to :practice_day
  belongs_to :practice_menu
end
