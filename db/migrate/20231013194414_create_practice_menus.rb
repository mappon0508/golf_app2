class CreatePracticeMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_menus do |t|
      t.text :title
      t.text :methods
      t.text :objective
      t.text :trick
      t.integer :level, default: 0, null: false

      t.timestamps
    end
  end
end
