# frozen_string_literal: true

class CreatePracticeAdvices < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_advices do |t|
      t.references :user, null: false, foreign_key: true
      t.references :golf_course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
