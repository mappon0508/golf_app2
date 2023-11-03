class AddDefaultAndNullConstraintToPracticeDays < ActiveRecord::Migration[7.0]
  def change
    change_column :practice_days, :practice_time, :integer, default: 0, null: false
  end
end
