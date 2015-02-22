namespace :insert do
  desc 'Insert initial amount of dollars for all students into database.'
  task :weekly_dollars => :environment do
    students = Student.all
    students.each do |student|
      if student.investable_dollars != 50
        student.investable_dollars = 50
        student.save!
      end
    end

  end
end