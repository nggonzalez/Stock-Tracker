class AddEndDateToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :end_date, :datetimera
  end
end
