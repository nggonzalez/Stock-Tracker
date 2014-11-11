
namespace :fix do
  desc 'Fix boolean flag marking current jobs.'
  task :employee_current => :environment do

    students = Student.all
    students.each do |student|
      if Offer.where(student_id: student.id, signed: true).present?
        lastOffer = Offer.where(student_id: student.id, signed: true).last
        if Employee.where(student_id: student.id).present?
          employment = Employee.where(student_id: student.id).load

          employment.each do |job|
            if job.team_id != lastOffer.team_id
              job.current = false
              job.save
            else
              job.current = true
              job.save
            end
          end
        end
      end
    end

  end
end