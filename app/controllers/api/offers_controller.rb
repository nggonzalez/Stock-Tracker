class API::OffersController < ApplicationController
  def index
    student = get_student
    offers = Offer.includes(:team).where(student_id: student.id).load
    offerArray = []
    offers.each do |offer|
      companyCeo = Student.where(netid: offer.team.ceo_id).select('name').first.name
      offerArray.push({
        :student => offer.student_id,
        :company => offer.team_id,
        :companyName => offer.team.company_name,
        :shares => offer.shares,
        :ceo => companyCeo,
        :responded => offer.answered,
        :signed => offer.signed,
        :dateSigned => offer.date_signed,
        :offerDate => offer.offer_date,
        :createdDate => offer.created_at
      })
    end
    render json: offerArray
  end

  def update
    offer = Offer.where(student_id: request.POST[:student], team_id: request.POST[:company], offer_date: request.POST[:offerDate], shares: request.POST[:shares]).first
    if offer
      puts offer
      offer.answered = true
      offer.signed = request.POST[:signed]
      offer.date_signed = Date.current
      offer.save
    end
    head :no_content
  end
end