namespace :update do
  desc 'Mark expired offers if not answered within 2 days.'
  task :expired_offers => :environment do
    Offer.includes(:team).where('answered = false AND created_at <= ?', 2.days.ago).each do |model|
      team = model.team
      team.total_shares = team.total_shares + model.shares
      team.held_shares = team.total_shares - model.shares
      team.save

      model.expired = true
      model.answered = true
      model.signed = false
      model.date_signed = Date.current
      model.save
    end
  end
end