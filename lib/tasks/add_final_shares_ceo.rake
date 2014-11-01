namespace :add_final_shares do
  desc 'Add last 800,000 in shares for each team.'
  task :teams => :environment do
    Team.all.each do |model|
      model.total_shares = model.total_shares + 800000
      model.save
    end
  end
end