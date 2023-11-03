class CreatePracticeSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_schedules do |t|
      t.references :practice_day, null: false, foreign_key: true
      t.references :practice_menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
