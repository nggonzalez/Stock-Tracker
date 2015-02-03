class Investment < ActiveRecord::Base

  belongs_to :student
  belongs_to :team

  validates :stock_value, numericality: { only_integer: false }
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
    @team = Team.find(@investment.team_id)
    @valuation = @team.valuations.last
    @student = Student.find(@investment.student_id)
  end

  def validate

    if @team.blank? || @student.blank?
      @investment.errors[:base] << "Team or student does not exist"
    elsif @student.investable_shares - @student.invested_shares < @investment.stock_value
      @investment.errors[:base] << "Insufficient shares"
    elsif @investment.stock_value != @valuation.value
      @investment.errors[:base] << "Stock value was tampered with"
    end

  end

end
