namespace :insert do
  desc 'Insert test valuations for all teams into database.'
  task :test_valuations => :environment do
    teams = Team.all
    counter = 1
    teams.each do |team|
      valuation = Valuation.new
      valuation.team_id = team.id
      valuation.valuation_round = 0
      valuation.grade = (1/counter) * 100
      valuation.previous_round_investments = 0
      valuation.total_investments = 0
      valuation.value = (1/counter) * 100 *0.45 + 0.55 * (counter * 5.34)
      valuation.save!
      counter = counter + 1
    end

  end
end