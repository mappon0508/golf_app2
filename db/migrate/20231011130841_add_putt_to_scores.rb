# frozen_string_literal: true

class AddPuttToScores < ActiveRecord::Migration[7.0]
  def change
    add_column :scores, :putt, :integer
  end
end
