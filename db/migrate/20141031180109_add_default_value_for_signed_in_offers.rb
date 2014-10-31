class AddDefaultValueForSignedInOffers < ActiveRecord::Migration
  def up
    change_column :offers, :signed, :boolean, :default => false
  end

  def down
    change_column :offers, :signed, :boolean, :default => nil
  end
end
