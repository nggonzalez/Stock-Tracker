class DropStudentsTable < ActiveRecord::Migration
  def change
    drop_table :students_tables
  end
end
