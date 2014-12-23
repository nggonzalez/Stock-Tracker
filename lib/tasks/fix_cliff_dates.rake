
namespace :fix do
  desc 'Fix cliff dates for all offers past the due date.'
  task :offer_cliff_dates => :environment do
    offers = Offer.all
    offers.each do |offer|
      if offer.cliff_date.to_date > Date.new(2014, 12, 11)
        offer.cliff_date = Date.new(2014, 12, 11)
        offer.save
      end
    end
  end
end