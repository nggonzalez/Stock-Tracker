
namespace :fix do
  desc 'Fix boolean flag marking answered offers.'
  task :offer_end_dates => :environment do
    students = Student.all
    students.each do |student|
      if student.offers.empty?
        next
      end
      current_team = Offer.where(student_id: student.id, signed: true).last
      offers = Offer.where(student_id: student.id, team_id: current_team.team_id).all
      offers.each do |offer|
        if offer.end_date.to_date != Date.new(2014, 12, 11)
          offer.end_date = Date.new(2014, 12, 11)
          offer.save!
        end
      end
    end
  end
end