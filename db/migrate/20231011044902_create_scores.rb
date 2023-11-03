class CreateScores < ActiveRecord::Migration[7.0]
  def change
    create_table :scores do |t|
      t.references :golf_play_record, null: false, foreign_key: true
      t.integer :content
      t.integer :tee_shot, default: 0, null: false
      t.integer :second_shot_distance, default: 0, null: false
      t.integer :approach_shot, default: 0, null: false
      t.integer :approach, default: 0, null: false
      t.integer :bunker_save, default: 0, null: false
      t.integer :long_putt, default: 0, null: false
      t.integer :short_putt, default: 0, null: false

      t.timestamps
    end
  end
end
