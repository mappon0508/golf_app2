class ChangePracticeTimeToIntegerInPracticeDays < ActiveRecord::Migration[7.0]
  def change
    def up
      change_column :practice_days, :practice_time, :integer, null: false
    end
  
    def down
      change_column :practice_days, :practice_time, :string
    end
  end
end
