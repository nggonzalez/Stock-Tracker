namespace :add_shares do
  desc 'Add last 1 million or 1.3 million in shares for each team depending on size.'
  task :teams => :environment do
    Team.includes(:employees).all.each do |model|
      if model.employees.length == 4
        model.total_shares = model.total_shares + 1000000
      elsif model.employees.length == 3
        model.total_shares = model.total_shares + 1300000
      else
        model.total_shares = model.total_shares + 1600000
      end
      model.save
    end
  end
end