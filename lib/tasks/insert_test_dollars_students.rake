namespace :insert do
  desc 'Insert test dollars for all students into database.'
  task :test_dollars => :environment do
    students = Student.all
    counter = 1
    students.each do |student|
      student.investable_shares = 4000000
      student.invested_shares = 0
      student.save!
    end

  end
end