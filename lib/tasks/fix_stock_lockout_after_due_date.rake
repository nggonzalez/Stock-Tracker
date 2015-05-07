
namespace :fix do
  desc 'Fix acceptance lockout after due date.'
  task :stock_lockout => :environment do
    students = Student.all

    students.each do |student|
      currentTeam = getCurrentTeam(student.id)
      offers = student.offers.where(team_id: currentTeam, answered: false).load
      offers.each do |offer|
        offer.answered = true
        offer.signed = true
        offer.date_signed = due_date
        offer.cliff_date = due_date

        offer.save!

        team = offer.team
        team.shares_distributed += offer.shares
        team.held_shares -= offer.shares
        team.save!
      end
    end
  end

  def getCurrentTeam(student_id)
    offer = Offer.where(student_id: student_id, signed: true).last
    return offer.team_id
  end

  def due_date
    return Date.new(2015, 4, 30)
  end
end