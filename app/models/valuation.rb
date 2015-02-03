class Valuation < ActiveRecord::Base

  belongs_to :team

  validates :grade, numericality: { only_integer: false }
  validates :previous_round_investments, numericality: { only_integer: false }
  validates :total_investments, numericality: { only_integer: false }
  validates :team_id, numericality: { only_integer: true }
  validates :valuation_round, numericality: { only_integer: true }

  # validate do |offer|
  #   OfferValidator.new(offer).validate
  # end
end

# class ValuationValidator
#   def initialize(offer)
#     @offer = offer
#     @team = Team.where(:id => @offer.team_id).first
#     @student = Student.where(:id => @offer.student_id).first
#   end

#   def validate

#     if @team.blank? || @student.blank?
#       @offer.errors[:base] << "Team or student does not exist"
#     elsif !@offer.signed && @offer.shares > @team.total_shares - @team.shares_distributed
#       @offer.errors[:base] << "Insufficient shares"
#     end

#   end

# end
