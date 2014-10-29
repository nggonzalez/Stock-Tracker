class ChangeStudentIdToIntegerInOffers < ActiveRecord::Migration
  def change
    change_column :offers, :student_id, :string
  end
end
