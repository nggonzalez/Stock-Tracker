class AddInvestmentColumnToStudent < ActiveRecord::Migration
  def change
    add_column :students, :investable_shares, :decimal
    add_column :students, :invested_shares, :decimal
  end
end
