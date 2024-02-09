# frozen_string_literal: true

class AddCategoryAndTimeToPracticeMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :practice_menus, :category, :integer, default: 0, null: false
    add_column :practice_menus, :time, :integer
  end
end
