class ChangeColumnsInValuationToHaveDefaults < ActiveRecord::Migration
  def change
    change_column :valuations, :previous_round_investments, :decimal, :default => 0
    change_column :valuations, :total_investments, :decimal, :default => 0
  end
end
