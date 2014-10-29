class RemoveNetidAndCompanyIdFromOffers < ActiveRecord::Migration
  def change
    remove_column :offers, :netid, :string
    remove_column :offers, :company_id, :integer
  end
end
