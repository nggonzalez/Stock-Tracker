
namespace :fix do
  desc 'Fix boolean flag marking current jobs.'
  task :employee_current => :environment do

    students = Student.all
    students.each do |student|
      if Offer.where(student_id: student.id).present?
        lastOffer = student.offers.where(signed: true).last
        if Employee.where(student_id: student.id).present?
          employment = student.employees.where.not(team_id: lastOffer.team_id).load

          employment.each do |job|
            job.current = false
            job.save
          end
        end
      end
    end

  end
end