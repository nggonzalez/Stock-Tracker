class API::OffersController < ApplicationController
  # before_create/update_action => calc totalShares - distributed

  def index
    student = get_student
    offers = Offer.includes(:team).where(student_id: student.id).load
    offerArray = []
    offers.each do |offer|
      companyCeo = Student.where(netid: offer.team.ceo_id).select("CONCAT_WS(' ', firstname, lastname) as name").first.name
      offerArray.push({
        :student => offer.student_id,
        :company => offer.team_id,
        :companyName => offer.team.company_name,
        :shares => offer.shares,
        :ceo => companyCeo,
        :answered => offer.answered,
        :signed => offer.signed,
        :dateSigned => offer.date_signed,
        :offerDate => offer.offer_date,
        :createdDate => offer.created_at
      })
    end
    render json: offerArray
  end

  def update
    student = get_student
    if student.admin
      render status: :unauthorized
    end
    offer = Offer.includes(:team).where(student_id: request.POST[:student], team_id: request.POST[:company], offer_date: request.POST[:offerDate], shares: request.POST[:shares]).first
    if offer
      offer.update!(offer_params)

      # Update share count for team
      team = offer.team
      if request.POST[:signed]
        team.shares_distributed += offer.shares
      end
      team.held_shares -= offer.shares
      team.save!

      offer.answered = true
      offer.date_signed = Date.current
      offer.save
      head :no_content
    end
    render status: :unprocessable_entity
  end

  def create
    student = get_student
    if !student.admin
      render status: :unauthorized
    end
    student_id = request.POST[:student]
    team_id = request.POST[:team]
    shares = request.POST[:shares]

    if Offer.where(student_id: student_id, team_id: params[:team]).present?
      lastOffer = Offer.where(student_id: student_id, team_id: params[:team]).last
      if !eligible_for_offer(lastOffer)
        render json: {}, status: :unauthorized
        return
      end
    end

    offer = Offer.new(new_offer_params)
    offer.student_id = student_id
    offer.team_id = team_id
    offer.shares = shares
    offer.offer_date = Date.current
    offer.cliff_date = Date.current + 14.days
    if offer.save
      team = Team.find(team_id)
      team.held_shares += shares
      team.save!
      head :no_content
    else
      render json: offer.errors, status: :unprocessable_entity
    end
  end

  private

  def offer_params
    params.require(:offer).permit(:signed)
  end

  def new_offer_params
    params.require(:offer).permit(:student_id, :team_id, :shares, :offer_date, :cliff_date)
  end

end
