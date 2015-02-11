class AddSharesToInvestments < ActiveRecord::Migration
  def change
    add_column :investments, :shares, :integer, default: 0
  end
end
