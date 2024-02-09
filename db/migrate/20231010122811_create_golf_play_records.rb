# frozen_string_literal: true

class CreateGolfPlayRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :golf_play_records do |t|
      t.references :golf_course, null: false, foreign_key: true
      t.date :play_day, null: false
      t.integer :weather, default: 0, null: false

      t.timestamps
    end
  end
end
