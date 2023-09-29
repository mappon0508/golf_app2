class AddBestScoreToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :best_score, :integer, null: false
  end
end
