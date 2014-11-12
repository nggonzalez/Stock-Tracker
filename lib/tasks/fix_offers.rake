
namespace :fix do
  desc 'Fix boolean flag marking current jobs.'
  task :offers => :environment do
    endDate = Date.new(2014, 12, 11)
    startDate = Date.new(2014, 10, 27)

    # allOffers = Offer.all
    # allOffers.each do |offer|
    #   if offer.created_at.to_date == startDate.to_date
    #     offer.end_date = Date.current
    #     offer.save!
    #   end
    # end

    students = Student.all
    students.each do |student|
      if Offer.where(student_id: student.id).present?
        offers = Offer.where(student_id: student.id).load
        if offers.length == 1
          offer = offers[0]
          offer.end_date = endDate
          offer.save!
        end
      end
    end

  end
end