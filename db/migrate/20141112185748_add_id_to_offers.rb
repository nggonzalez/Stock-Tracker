class AddIdToOffers < ActiveRecord::Migration
  def up
    execute "ALTER TABLE offers DROP CONSTRAINT offers_pkey;"
    add_column :offers, :id, :primary_key
  end

  def down
    remove_column :offers, :id
  end
end
