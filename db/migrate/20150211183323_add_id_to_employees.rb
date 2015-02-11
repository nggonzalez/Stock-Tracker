class AddIdToEmployees < ActiveRecord::Migration
  def up
    execute "ALTER TABLE employees DROP CONSTRAINT employees_pkey;"
    add_column :employees, :id, :primary_key
  end

  def down
    remove_column :employees, :id, :primary_key
  end
end
