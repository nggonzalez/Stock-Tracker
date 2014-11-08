class CreateMentors < ActiveRecord::Migration
  def change
    create_table :mentors, id:false do |t|
      t.integer :team_id, null:false
      t.integer :fellow_id, null:false
    end
  end
end
