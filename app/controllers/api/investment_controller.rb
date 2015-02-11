class API::InvestmentController < ApplicationController
  def index
    student = get_user
    valuations = Valuation.includes(:team).where(valuation_round: Valuation.where(live: true).maximum("valuation_round")).load
    formattedValuationsArray = []
    valuations.each do |valuation|
      formattedValuation = {}
      team = valuation.team
      formattedValuation[:company_name] = team.company_name
      formattedValuation[:team_id] = team.id
      formattedValuation[:ceo] = Student.where(netid: team.ceo_id).select("CONCAT_WS(' ', firstname, lastname) as name").first.name
      formattedValuation[:value] = valuation.value
      formattedValuation[:change] = (valuation.value - Valuation.where(team_id: valuation.team_id, valuation_round: valuation.valuation_round - 1).first.value)
      formattedValuation[:currentInvestmentDollars] = 0
      formattedValuation[:currentInvestmentShares] = 0
      Investment.where(team_id: team.id).load.each do |investment|
        formattedValuation[:currentInvestmentDollars] += investment.investment
        formattedValuation[:currentInvestmentShares] += investment.shares
      end
      formattedValuationsArray.push(formattedValuation)
    end
    render json: {student: student, investment: formattedValuationsArray}, status: :ok
  end

  def invest
    # create a new entry in the table
    # update student values
    student = get_user
    round = Valuation.where(live: true).maximum("valuation_round")
    investment = Investment.new
    investment.student_id = student.id
    investment.team_id = request.POST['team_id']
    investment.shares = request.POST['shares']
    investment.investment = request.POST['shares'] * Valuation.where(team_id: request.POST['team_id'], valuation_round: round).first.value
    investment.round = Valuation.where(live: true).maximum("valuation_round")
    investment.save!

    student.invested_shares += investment.investment
    student.save!

    head :no_content
  end

  private

end
