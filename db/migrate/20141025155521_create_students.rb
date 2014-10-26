class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :netid
      t.string :name
      t.boolean :admin
    end
  end
end
