class MakeStudentsTableAgain2 < ActiveRecord::Migration
  def change
    drop_table :students_tables
    create_table :students do |t|
      t.string :netid
      t.string :name
      t.boolean :admin
    end
  end
end
