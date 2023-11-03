class ChangePracticeTimeColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :practice_days, :practice_time, :string
  end
end
