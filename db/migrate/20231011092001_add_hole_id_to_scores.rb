# frozen_string_literal: true

class AddHoleIdToScores < ActiveRecord::Migration[7.0]
  def change
    add_reference :scores, :hole, null: false, foreign_key: true
  end
end
