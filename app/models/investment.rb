class Investment < ActiveRecord::Base

  belongs_to :student
  belongs_to :team

  validates :round, numericality: { only_integer: true }
  validates :investment, numericality: { only_integer: false }
  validates :student_id, numericality: { only_integer: true }
  validates :team_id, numericality: { only_integer: true }

  validate do |investment|
    InvestmentValidator.new(investment).validate
  end
end

class InvestmentValidator
  def initialize(investment)
    @investment = investment
    @team = Team.where(id: @investment.team_id).first
    @student = Student.where(id: @investment.student_id).first
  end

  def validate
    if @team.blank? || @student.blank?
      @investment.errors[:base] << "Team or student does not exist"
    elsif @student.investable_dollars - @student.invested_dollars < @investment.investment
      @investment.errors[:base] << "Insufficient shares"
    end

  end

end
