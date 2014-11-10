
namespace :fix do
  desc 'Fix boolean flag marking current jobs.'
  task :employee_current => :environment do

    students = Student.all
    students.each do |student|
      e = student.employees.last
      if e
        e.current = true
        e.save!
      end
    end

  end
end