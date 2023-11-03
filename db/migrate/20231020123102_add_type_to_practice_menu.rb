class AddTypeToPracticeMenu < ActiveRecord::Migration[7.0]
  def change
    add_column :practice_menus, :type, :integer, default: 0, null: false
  end
end
