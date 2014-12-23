
namespace :test do
  desc 'Insert test employee into the database.'
  task :student_ceo => :environment do
    s = Student.where(netid: "ngg23").first
    s.admin = true
    s.save!
  end
end