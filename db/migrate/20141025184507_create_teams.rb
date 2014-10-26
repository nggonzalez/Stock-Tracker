class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :company_id
      t.integer :total_shares
      t.integer :shares_distributed
      t.string :ceo_id

      t.timestamps
    end
  end
end
