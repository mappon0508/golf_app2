class ChangeNameToNotNullInGolfCourses < ActiveRecord::Migration[7.0]
  def change
    change_column :golf_courses, :name, :string, null: false
  end
end
