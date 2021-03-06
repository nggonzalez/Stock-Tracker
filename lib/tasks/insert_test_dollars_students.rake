namespace :insert do
  desc 'Insert initial amount of dollars for all students into database.'
  task :initial_dollars => :environment do
    students = Student.all
    students.each do |student|
      student.investable_dollars = 50
      student.invested_dollars = 0
      student.save!
    end

  end
end