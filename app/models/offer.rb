class Offer < ActiveRecord::Base
  belongs_to :student
  belongs_to :team

  validates :answered, inclusion: {in: [true, false] }
  validates :signed, inclusion: {in: [true, false] }
  validates :shares, numericality: { only_integer: true }
  validates :student_id, numericality: { only_integer: true }
  validates :team_id, numericality: { only_integer: true }
end
