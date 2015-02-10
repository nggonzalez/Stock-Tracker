class API::ValuationController < ApplicationController
  before_action :mentor_check

  def index
    valuations = Valuation.includes(:team).order(valuation_round: :desc).load
    formattedValuationObjectArray = []
    formattedValuationObject = {}
    valuations.each do |valuation|
      if formattedValuationObject[:round].nil?
        formattedValuationObject[:round] = valuation.valuation_round
        formattedValuationObject[:valuations] = []
      elsif formattedValuationObject[:round] != valuation.valuation_round
        formattedValuationObjectArray.push(formattedValuationObject)
        formattedValuationObject = {}
        formattedValuationObject[:round] = valuation.valuation_round
        formattedValuationObject[:valuations] = []
      end
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
      formattedValuationObject[:valuations].push(formattedValuation)
    end
    formattedValuationObjectArray.push(formattedValuationObject)
    render json: formattedValuationObjectArray, status: :ok
  end

end
