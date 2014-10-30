class API::OffersController < ApplicationController
  # before_create/update_action => calc totalShares - distributed

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
    offer = Offer.where(student_id: request.POST[:student], team_id: request.POST[:company], created_at: request.POST[:createdDate], shares: request.POST[:shares]).first
    if offer
      offer.update!(offer_params)
      offer.answered = true
      offer.date_signed = Date.current
      offer.save
    end
    head :no_content
  end

  private

  def offer_params
    params.require(:offer).permit(:signed)
  end

end
