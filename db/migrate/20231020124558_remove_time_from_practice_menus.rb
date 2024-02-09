# frozen_string_literal: true

class RemoveTimeFromPracticeMenus < ActiveRecord::Migration[7.0]
  def change
    remove_column :practice_menus, :time
  end
end
