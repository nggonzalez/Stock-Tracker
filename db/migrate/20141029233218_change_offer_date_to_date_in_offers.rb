class ChangeOfferDateToDateInOffers < ActiveRecord::Migration
  def change
    change_column :offers, :offer_date, :date
  end
end
