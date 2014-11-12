
namespace :insert do
  desc 'Insert test employee into the database.'
  task :test_employee => :environment do
    s = Student.new
    s.firstname = "Nicholas"
    s.lastname = "Gonzalez"
    s.email = "nicholas.gonzalez@yale.edu"
    s.netid = "ngg23"
    s.save!

    startDate = Date.new(2014, 10, 27)

    t = Team.first

    e = Employee.new
    e.team_id = t.id
    e.current = true
    e.student_id = s.id
    e.save!

    o = Offer.new
    o.shares = 300000
    o.cliff_date = startDate + 14.days
    o.offer_date = startDate
    o.created_at = startDate
    o.answered = true
    o.signed = true
    o.date_signed = startDate
    o.student_id = s.id
    o.team_id = t.id
    o.end_date = Date.new(2014, 12, 11)
    o.save!
  end
end