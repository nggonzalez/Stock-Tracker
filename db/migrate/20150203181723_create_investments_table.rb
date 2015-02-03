class CreateInvestmentsTable < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :student_id
      t.integer :team_id
      t.decimal :stock_value
      t.decimal :investment
      t.datetime :investment_date

      t.timestamps
    end
  end
end
