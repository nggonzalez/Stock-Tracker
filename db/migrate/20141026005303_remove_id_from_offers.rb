class RemoveIdFromOffers < ActiveRecord::Migration
  def change
    remove_column :offers, :id, :integer, :primary_key
  end
end
