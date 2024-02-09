# frozen_string_literal: true

class ChangeColumnTypeInPracticeMenus < ActiveRecord::Migration[7.0]
  def change
    rename_column :practice_menus, :type, :practice_type
  end
end
