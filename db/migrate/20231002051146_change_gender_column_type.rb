class ChangeGenderColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :gender, :integer, default: 0, null: false
  end
end
