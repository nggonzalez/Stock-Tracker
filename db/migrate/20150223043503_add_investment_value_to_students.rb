class AddInvestmentValueToStudents < ActiveRecord::Migration
  def change
    add_column :students, :investments_value, :decimal, :default => 0
  end
end
