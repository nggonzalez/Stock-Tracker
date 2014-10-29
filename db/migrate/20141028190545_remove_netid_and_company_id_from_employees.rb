class RemoveNetidAndCompanyIdFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :netid, :string
    remove_column :employees, :company_id, :integer
  end
end
