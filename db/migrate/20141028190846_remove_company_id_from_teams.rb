class RemoveCompanyIdFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :company_id, :integer
  end
end
