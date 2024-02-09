# frozen_string_literal: true

class CreateHoles < ActiveRecord::Migration[7.0]
  def change
    create_table :holes do |t|
      t.references :golf_course, null: false, foreign_key: true
      t.integer :hole, null: false
      t.integer :par, null: false, default: 0

      t.timestamps
    end
  end
end
