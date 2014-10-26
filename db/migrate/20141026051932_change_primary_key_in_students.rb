class ChangePrimaryKeyInStudents < ActiveRecord::Migration
  def change
    drop_table :students
    create_table :students, :primary_key => :netid do |t|
      t.string  :name
      t.boolean :admin, default: false
    end
    change_column :students, :netid, :string
  end
end
