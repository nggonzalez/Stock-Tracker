class AddPrimaryKeyToOffersAndToEmployees < ActiveRecord::Migration
  def change
    execute "ALTER TABLE offers ADD PRIMARY KEY (created_at,student_id, team_id);"
    execute "ALTER TABLE employees ADD PRIMARY KEY (created_at,student_id, team_id);"
  end
end
