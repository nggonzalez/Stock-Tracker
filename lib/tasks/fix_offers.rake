
namespace :fix do
  desc 'Fix boolean flag marking answered offers.'
  task :offers => :environment do
    offers = Offer.all
    offers.each do |offer|
      if offer.signed && !offer.answered
        offer.answered = true
        offer.save!
      end
    end

  end
end