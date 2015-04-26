namespace :fix do
  desc 'Fix boolean flag marking answered offers.'
  task :grade_mistake => :environment do
    # Here is what I need to do
    round = 6
    team = Team.where(company_name: 'Face2Face').first
    previousValue = Valuation.where(team_id: team.id, valuation_round: round-1).first.value

    valuation = Valuation.where(team_id: team.id, valuation_round: round).first
    valuation.grade = 105.0
    valuation.live = true
    valuation.value = previousValue + ((valuation.grade - 80) * 0.001)/20 +  ((0.001/200) * valuation.previous_round_investments)
    valuation.save!

    students = Student.all
    students.each do |student|
      student.investments_value = calculateAllInvestmentsValue(student.id)
      # student.investable_dollars += 50 - (student.investable_dollars - student.invested_dollars)
      student.save!
    end
    # End of live code
  end

  def getCurrentTeam(student_id)
    offer = Offer.where(student_id: student_id, signed: true).last
    return offer.team_id
  end

  def calculateTeamInvestmentsValue(student_id, team_id, round, round_value)
    investmentData = {}
    investmentData[:round] = round
    investmentData[:sharePrice] = round_value
    investmentData[:team_id] = team_id
    investmentData[:company_name] = Team.where(id: team_id).first.company_name
    investmentData[:dollarValue] = 0
    investments = Investment.where(student_id: student_id, team_id: team_id).where("round <= #{round}").load
    investments.each do |investment|
      investmentData[:dollarValue] += investment.shares * round_value
    end
    investmentData
  end

  def calculateAllInvestmentsValue(student_id)
    currentTeam = getCurrentTeam(student_id)
    teams = Team.where("teams.dissolved = false").all
    round = Valuation.where(live: true).maximum("valuation_round")
    investmentsValue = 0
    teams.each do |team|
      round_value = Valuation.where(team_id: team.id, valuation_round: round).first.value
      investmentsValue += calculateTeamInvestmentsValue(student_id, team.id, round, round_value)[:dollarValue]
    end
    investmentsValue
  end

end