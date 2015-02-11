class ChangeStockValueToRoundInInvestments < ActiveRecord::Migration
  def change
    rename_column :investments, :stock_value, :round
    change_column :investments, :round,  :integer
  end
end
