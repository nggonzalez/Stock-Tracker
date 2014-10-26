class CreateStudentTeamTable < ActiveRecord::Migration
  def change
    create_table :students_teams, id:false do |t|
      t.integer :student_id
      t.integer :team_id
    end
  end
end
