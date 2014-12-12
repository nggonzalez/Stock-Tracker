
namespace :fix do
  desc 'Fix boolean flag marking answered offers.'
  task :offers => :environment do
    offers = Offer.all
    offers.each do |offer|
      if offer.signed && !offer.answered
        offer.answered = true
        offer.save!
      elsif offer.signed && offer.date_signed.nil?
        offer.date_signed = offer.updated_at.to_date
        offer.save!
      end
    end

  end
end