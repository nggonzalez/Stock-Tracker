
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
            puts job.team_id != lastOffer.team_id
            if job.team_id != lastOffer.team_id
              teamId = job.team_id
              startDate = job.created_at
              job.delete

              e = Employee.new
              e.student_id = student.id
              e.team_id = teamId
              e.current = false
              e.created_at = startDate
              e.save!
            end
          end
        end
      end
    end

  end
end