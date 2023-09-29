class AddGolfExperienceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :golf_experience, :integer, null: false
  end
end
