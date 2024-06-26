# frozen_string_literal: true

class AddUserIdToGolfPlayRecords < ActiveRecord::Migration[7.0]
  def change
    add_reference :golf_play_records, :user, null: false, foreign_key: true
  end
end
