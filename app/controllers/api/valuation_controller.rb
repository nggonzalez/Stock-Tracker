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
        formattedValuationObject[:live] = valuation.live
      elsif formattedValuationObject[:round] != valuation.valuation_round
        formattedValuationObjectArray.push(formattedValuationObject)
        formattedValuationObject = {}
        formattedValuationObject[:round] = valuation.valuation_round
        formattedValuationObject[:valuations] = []
        formattedValuationObject[:live] = valuation.live
      end
      formattedValuation = create_formatted_valuation(valuation, formattedValuationObject[:round])
      formattedValuationObject[:valuations].push(formattedValuation)
    end
    formattedValuationObjectArray.push(formattedValuationObject)
    render json: formattedValuationObjectArray, status: :ok
  end


  def save
    valuations = request.POST['valuations']
    valuations.each do |valuation|
      newVal = Valuation.new
      newVal.team_id = valuation['team_id']
      newVal.grade = valuation['grade']
      newVal.valuation_round = Valuation.where(live: true).maximum("valuation_round") + 1
      newVal.save!
    end
    self.index
  end


  def update
    valuations = request.POST['valuations']
    valuations.each do |valuation|
      val = Valuation.find(valuation['id'])
      val.grade = valuation['grade']
      val.save!
    end
    self.index
  end


  def live
    round = request.POST['round']
    valuations = request.POST['valuations']
    valuations.each do |val|
      valuation = Valuation.find(val['id'])
      previousValue = Valuation.where(team_id: valuation['team_id'], valuation_round: round-1).first.value
      valuation.grade = val['grade']
      valuation.live = true
      Investment.where(team_id: valuation['team_id']).where("round < #{round}").order(:round).load.each do |investment|
        if investment.round < round
          valuation.total_investments += investment.investment
          if investment.round == round - 1
            valuation.previous_round_investments += investment.investment
          end
        end
      end
      valuation.value = previousValue + ((val['grade'] - 80) * 0.001)/20 +  ((0.001/200) * valuation.previous_round_investments)
      valuation.save!
    end
    students = Student.all
    student.each do |student|
      student.investments_value = calculateAllInvestmentsValue(student.id)
      student.save!
    end
    self.index
  end


private

  def create_formatted_valuation(valuation, round)
    formattedValuation = {}
    team = valuation.team
    formattedValuation[:id] = valuation.id
    formattedValuation[:company_name] = team.company_name
    formattedValuation[:team_id] = team.id
    formattedValuation[:ceo] = Student.where(netid: team.ceo_id).select("CONCAT_WS(' ', firstname, lastname) as name").first.name
    formattedValuation[:grade] = valuation.grade
    formattedValuation[:value] = valuation.value
    formattedValuation[:change] = 0
    if round != 0
      formattedValuation[:change] = (valuation.value - Valuation.where(team_id: valuation.team_id, valuation_round: round - 1).first.value)
    end
    formattedValuation[:currentInvestment] = 0
    formattedValuation[:previousRoundInvestment] = 0
    Investment.where(team_id: team.id).where("round < #{round}").order(:round).load.each do |investment|
      if investment.round < round
        formattedValuation[:currentInvestment] += investment.investment
        if investment.round == round - 1
          formattedValuation[:previousRoundInvestment] += investment.investment
        end
      end
    end

    return formattedValuation
  end

end
