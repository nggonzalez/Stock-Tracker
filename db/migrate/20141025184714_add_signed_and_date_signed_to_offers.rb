class AddSignedAndDateSignedToOffers < ActiveRecord::Migration
  def up
    add_column :offers, :signed, :boolean
    add_column :offers, :date_signed, :datetime
  end
  def down
    remove_column :offers, :signed
    remove_column :offers, :date_signed
  end
end
