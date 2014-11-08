class CreateStaff < ActiveRecord::Migration
  def change
    create_table :fellows do |t|
      t.string :netid, null:false
      t.string :firstname, null:false
      t.string :lastname, null:false
      t.boolean :professor, default:false
      t.string :email, null:false
    end
  end
end
