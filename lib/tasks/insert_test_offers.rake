
namespace :insert do
  desc 'Insert test employee into the database.'
  task :test_offers => :environment do
    s = Student.where(netid: "ngg23").first
    t = Team.first

    startDate = Date.new(2014, 10, 27)

    for i in 0..10
        o = Offer.new
        o.shares = 300000
        o.cliff_date = Date.current + 14.days
        o.offer_date = Date.current
        o.created_at = startDate
        o.answered = false
        o.signed = false
        o.date_signed = startDate
        o.student_id = s.id
        o.team_id = t.id + i
        o.end_date = Date.new(2014, 12, 11)
        o.save!
    end
  end
end