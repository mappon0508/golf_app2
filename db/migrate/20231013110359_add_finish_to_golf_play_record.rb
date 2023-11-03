class AddFinishToGolfPlayRecord < ActiveRecord::Migration[7.0]
  def change
    add_column :golf_play_records, :finish, :integer, default: 0, null: false
  end
end
