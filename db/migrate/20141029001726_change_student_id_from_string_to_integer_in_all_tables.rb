class ChangeStudentIdFromStringToIntegerInAllTables < ActiveRecord::Migration
  def change
    change_column :employees, :student_id, 'integer USING CAST(student_id AS integer)'
    change_column :offers, :student_id, 'integer USING CAST(student_id AS integer)'
  end
end
