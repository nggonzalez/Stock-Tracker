namespace :add do
  desc 'Add last 300,000 in shares for each team.'
  task :extra_shares => :environment do
    Team.all.each do |model|
      model.total_shares = model.total_shares + 300000
      model.save
    end
  end
end