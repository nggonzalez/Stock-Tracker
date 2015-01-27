namespace :print do
  desc 'Print teams and ceos to console.'
  task :teams_ceos => :environment do
    teamInfo = []
    Team.all.each do |team|
      teamData = {}
      teamData[:name] = team.company_name
      s = Student.where(netid: team.ceo_id).first
      teamData[:ceo] = s.firstname + ' ' + s.lastname
      teamInfo.push(teamData);
    end
    teamInfo.each do |team|
      print team[:name]
      print "\t\t\t\t"
      print team[:ceo]
      puts ""
    end

  end
end