namespace :remove do
  desc 'Remove investments made for the week'
  task :weeks_investments => :environment do
    # Here is what I need to do
    currentRound = Valuation.where(live: true).maximum("valuation_round")

    investments = Investment.where(round: currentRound).load
    investments.each do |investment|
      student = Student.where(id: investment.student_id).first
      student.invested_dollars -= investment.investment
      student.save!
      investment.destroy!
    end
    Investment.where(round: currentRound).destroy_all

    students = Student.all
    students.each do |student|
      student.investable_dollars = student.invested_dollars
      student.investments_value = calculateAllInvestmentsValue(student.id)
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