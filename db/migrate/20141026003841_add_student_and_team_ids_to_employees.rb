class AddStudentAndTeamIdsToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :student_id, :integer
    add_column :employees, :team_id, :integer
  end
end
