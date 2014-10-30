class RevertOfferDateToDateTimeInOffers < ActiveRecord::Migration
  def change
    change_column :offers, :offer_date, :datetime
  end
end
