class ChangeStudentIdToIntegerInAllTables < ActiveRecord::Migration
  def change
    change_column :employees, :student_id, :string
  end
end
