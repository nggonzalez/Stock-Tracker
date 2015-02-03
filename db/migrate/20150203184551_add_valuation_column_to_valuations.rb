class AddValuationColumnToValuations < ActiveRecord::Migration
  def change
    add_column :valuations, :value, :decimal
  end
end
