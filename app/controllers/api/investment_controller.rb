class API::InvestmentController < ApplicationController
  def index
    student = get_user
    valuations = Valuation.includes(:team).where(valuation_round: Valuation.maximum("valuation_round")).load
    formattedValuationsArray = []
    valuations.each do |valuation|
      formattedValuation = {}
      team = valuation.team
      formattedValuation[:company_name] = team.company_name
      formattedValuation[:team_id] = team.id
      formattedValuation[:ceo] = Student.where(netid: team.ceo_id).select("CONCAT_WS(' ', firstname, lastname) as name").first.name
      formattedValuation[:value] = valuation.value
      formattedValuation[:change] = 0
      formattedValuation[:currentInvestment] = 0
      Investment.where(team_id: team.id).load.each do |investment|
        formattedValuation[:currentInvestment] += investment.investment
      end
      formattedValuationsArray.push(formattedValuation)
    end
    render json: {student: student, investment: formattedValuationsArray}, status: :ok
  end

  def invest
    # create a new entry in the table
    # update student values
    student = get_user
    investment = Investment.new
    investment.student_id = student.id
    investment.team_id = request.POST['team_id']
    investment.investment = request.POST['dollars']
    investment.stock_value = Valuation.where(team_id: request.POST['team_id'], valuation_round: Valuation.maximum("valuation_round")).first.value
    investment.save!

    student.invested_shares += investment.investment
    student.save!

    head :no_content
  end

  private

end
