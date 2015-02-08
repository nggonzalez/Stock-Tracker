class AddLiveColumnToValuations < ActiveRecord::Migration
  def change
    add_column :valuations, :live, :boolean, default:false
  end
end
