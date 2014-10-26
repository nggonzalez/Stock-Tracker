class RemoveIdFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :id, :integer, :primary_key
  end
end
