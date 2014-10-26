class CreateStudentsTable < ActiveRecord::Migration
  def change
    create_table :students_tables do |t|
      t.string :netid
      t.string :name
      t.boolean :admin
    end
  end
end
