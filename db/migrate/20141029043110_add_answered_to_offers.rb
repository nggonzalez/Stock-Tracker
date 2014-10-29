class AddAnsweredToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :answered, :boolean, default:false
  end
end
