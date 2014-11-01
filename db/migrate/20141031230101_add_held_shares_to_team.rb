class AddHeldSharesToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :held_shares, :integer, :default => 0
  end
end
