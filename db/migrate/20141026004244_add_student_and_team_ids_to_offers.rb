class AddStudentAndTeamIdsToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :student_id, :integer
    add_column :offers, :team_id, :integer
  end
end
