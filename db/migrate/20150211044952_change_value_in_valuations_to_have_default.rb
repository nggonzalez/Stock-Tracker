class ChangeValueInValuationsToHaveDefault < ActiveRecord::Migration
  def change
    change_column :valuations, :value, :decimal, :default => 0
  end
end
