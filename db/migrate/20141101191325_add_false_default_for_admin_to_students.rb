class AddFalseDefaultForAdminToStudents < ActiveRecord::Migration
  def change
    change_column :students, :admin, :boolean, :default => false
  end
end
