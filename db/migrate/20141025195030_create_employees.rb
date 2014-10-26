class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :netid
      t.integer :company_id
      t.boolean :current

      t.timestamps
    end
  end
end
