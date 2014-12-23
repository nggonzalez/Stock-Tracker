
namespace :fix do
  desc 'Fix boolean flag marking answered offers.'
  task :offer_cliff_dates => :environment do
    offers = Offer.all
    offers.each do |offer|
      if offer.cliff_date.to_date > Date.new(2014, 12, 11)
        offer.cliff_date = Date.new(2014, 12, 11)
        offer.save!
      end
    end
  end
end