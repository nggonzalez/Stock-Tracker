
namespace :fix do
  desc 'Fix boolean flag marking current jobs.'
  task :employee_current => :environment do

    students = Student.all
    students.each do |student|
      lastOffer = student.offers.where(signed: true).last
      employment = student.employees

      employment.each do |job|
        if job.team_id != lastOffer.team_id
          job.current = false
          job.save!
        elsif job.team_id == lastOffer.team_id
          job.current = true
          job.save!
        end
      end
    end

  end
end