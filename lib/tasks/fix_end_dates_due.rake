
namespace :fix do
  desc 'Fix cliff dates for all offers past the due date.'
  task :offer_end_dates_to_due => :environment do
    offers = Offer.all
    offers.each do |offer|
      if offer.end_date.to_date > Date.new(2014, 12, 11)
        offer.end_date = Date.new(2014, 12, 11)
        offer.save
      end
    end
  end
end

