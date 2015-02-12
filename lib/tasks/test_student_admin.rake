
namespace :insert do
  desc 'Insert test employee into the database.'
  task :student_ceo => :environment do
    s = Student.new
    s.firstname = "Nicholas"
    s.lastname = "Gonzalez"
    s.email = "nicholas.gonzalez@yale.edu"
    s.netid = "ngg23"
    s.admin = true
    s.save!
  end
end