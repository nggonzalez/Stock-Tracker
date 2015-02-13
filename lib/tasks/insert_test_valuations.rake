namespace :insert do
  desc 'Insert test valuations for all teams into database.'
  task :test_valuations => :environment do
    teams = Team.all
    teams.each do |team|
      valuation = Valuation.new
      valuation.team_id = team.id
      valuation.valuation_round = 0
      valuation.grade = 100
      valuation.previous_round_investments = 0
      valuation.total_investments = 0
      valuation.value = 10000
      valuation.live = true
      valuation.save!
    end

  end
end