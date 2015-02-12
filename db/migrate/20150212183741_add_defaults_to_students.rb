class AddDefaultsToStudents < ActiveRecord::Migration
  def change
    change_column :students, :investable_shares, :decimal, :default => 0
    change_column :students, :invested_shares, :decimal, :default => 0
    rename_column :students, :investable_shares, :investable_dollars
    rename_column :students, :invested_shares, :invested_dollars
  end
end
