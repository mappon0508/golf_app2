# frozen_string_literal: true

class AddWeakPointsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :weak_point, :integer, default: 0, null: false
    add_column :users, :very_weak_point, :integer, default: 0, null: false
  end
end
