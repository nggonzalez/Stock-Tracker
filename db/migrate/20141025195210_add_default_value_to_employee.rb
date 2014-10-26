class AddDefaultValueToEmployee < ActiveRecord::Migration
  def up
  change_column :employees, :current, :boolean, :default => false
  end

  def down
    change_column :employees, :current, :boolean, :default => nil
  end
end
