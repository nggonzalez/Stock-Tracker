class AddExpiredToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :expired, :boolean, :default => false
  end
end
