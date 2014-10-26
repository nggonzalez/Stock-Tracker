class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :netid
      t.integer :company_id
      t.integer :shares
      t.date :cliff_date
      t.datetime :offer_date

      t.timestamps
    end
  end
end
