class AddLastNameAndEmailToStudents < ActiveRecord::Migration
  def change
    change_column :students, :name, :string, :null => false
    rename_column :students, :name, :firstname
    add_column :students, :lastname, :string, :null => false
    add_column :students, :email, :string, :null => false
  end
end
