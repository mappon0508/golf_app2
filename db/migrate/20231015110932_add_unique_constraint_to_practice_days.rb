# frozen_string_literal: true

class AddUniqueConstraintToPracticeDays < ActiveRecord::Migration[7.0]
  def change
    add_index :practice_days, %i[user_id content], unique: true
  end
end
