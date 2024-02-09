# frozen_string_literal: true

class ChangeHoleColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :holes, :hole, :number
  end
end
