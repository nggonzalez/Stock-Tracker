class MakeStudentsTableAgain < ActiveRecord::Migration
  def change
    drop_table :students
    create_table :students_tables do |t|
      t.string :netid
      t.string :name
      t.boolean :admin
    end
  end
end
