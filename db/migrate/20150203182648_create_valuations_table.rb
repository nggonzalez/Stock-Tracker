class CreateValuationsTable < ActiveRecord::Migration
  def change
    create_table :valuations do |t|
      t.integer :team_id
      t.integer :valuation_round
      t.decimal :grade
      t.decimal :previous_round_investments
      t.decimal :total_investments

      t.timestamps
    end
  end
end
