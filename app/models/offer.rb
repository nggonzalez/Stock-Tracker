class Offer < ActiveRecord::Base

  belongs_to :student
  belongs_to :team

  validates :answered, inclusion: {in: [true, false] }
  validates :signed, inclusion: {in: [true, false] }
  validates :shares, numericality: { only_integer: true }
  validates :student_id, numericality: { only_integer: true }
  validates :team_id, numericality: { only_integer: true }

  validate do |offer|
    OfferValidator.new(offer).validate
  end
end

class OfferValidator
  def initialize(offer)
    @offer = offer
    @team = Team.where(:id => @offer.team_id).first
    @student = Student.where(:id => @offer.student_id).first
  end

  def validate
    if (Date.current - Date.new(2014, 10, 27)).to_i < 14
      @offer.errors[:base] << "Offers cannot be made before Nov. 10"
    elsif @team.blank? || @student.blank?
      @offer.errors[:base] << "Team or student does not exist"
    elsif @offer.shares > @team.total_shares - @team.shares_distributed - @team.held_shares
      @offer.errors[:base] << "Insufficient shares"
    end
  end

 end
