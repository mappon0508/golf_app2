# frozen_string_literal: true

class CreatePracticeDays < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_days do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :practice_time
      t.date :content

      t.timestamps
    end
  end
end
