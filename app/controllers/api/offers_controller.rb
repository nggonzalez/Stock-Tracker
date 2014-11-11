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
      render json: {}, status: :unauthorized
    end
    if Offer.includes(:team).where(student_id: request.POST[:student], team_id: request.POST[:company], shares: request.POST[:shares]).present?
      offer = Offer.includes(:team).where(student_id: request.POST[:student], team_id: request.POST[:company], shares: request.POST[:shares]).last
      offer.update!(offer_params)

      oldTeamId = -1
      team = offer.team
      if request.POST[:signed]
        team.shares_distributed += offer.shares
        # If new team
          # then create new employee record
          # Mark all other employee records as not current
          # Update all offers without the matching team id
        currentTeam = Employee.where(student_id: student.id, current: true).first
        if currentTeam.team_id != team.id
          oldTeamId = currentTeam.team_id
          currentTeam.current = false
          currentTeam.save!

          # new Employee Record
          e = Employee.new
          e.student_id = student.id
          e.team_id = team.id
          e.current = true
          e.save!

          # update old active offers
          offers = Offer.where(student_id: student.id, team_id: oldTeamId).load
          oldTeam = Team.where(id: oldTeamId).first
          offers.each do |oldOffer|
            oldOffer.end_date = Date.current
            oldOffer.save!
            offerData = calculateEquityData(oldOffer)
            oldTeam.shares_distributed -= (offerData[:totalShares] - offerData[:earnedShares])
            oldTeam.save!
          end
        end
      end
      team.held_shares -= offer.shares
      team.save!

      offer.answered = true
      offer.date_signed = Date.current
      offer.save

      ceo = Student.where(netid: team.ceo_id).first
      mentor = Mentor.includes(:fellow).where(team_id: team.id).first
      fellow = mentor.fellow

      if request.POST[:signed]
        OfferUpdates.offer_accepted_email(student, team, student.email).deliver
        OfferUpdates.offer_accepted_email(student, team, ceo.email).deliver
        OfferUpdates.offer_accepted_email(student, team, fellow.email).deliver
        if oldTeam != -1 && oldTeam != team.id
          oldCompany = Team.where(id: oldTeam).first
          ceo = Student.where(netid: oldCompany.ceo_id).first
          mentor = Mentor.includes(:fellow).where(team_id: oldTeam).first
          fellow = mentor.fellow
          OfferUpdates.offer_accepted_email(student, team, ceo.email).deliver
          OfferUpdates.offer_accepted_email(student, team, fellow.email).deliver
        end
      else
        OfferUpdates.offer_rejected_email(student, team, student.email).deliver
        OfferUpdates.offer_rejected_email(student, team, ceo.email).deliver
        OfferUpdates.offer_rejected_email(student, team, fellow.email).deliver
      end
      head :no_content
    else
      render json: {}, status: :unprocessable_entity
    end
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
    offer.end_date = due_date
    if offer.save
      team = Team.find(team_id)
      team.held_shares += shares
      team.save!

      recruit = Student.where(id: student_id).select("CONCAT_WS(' ', firstname, lastname) as name, email").first
      ceo = Student.where(netid: team.ceo_id).first
      mentor = Mentor.includes(:fellow).where(team_id: team.id).first
      fellow = mentor.fellow

      OfferUpdates.new_offer_email(recruit, team, recruit.email).deliver
      OfferUpdates.new_offer_email(recruit, team, ceo.email).deliver
      OfferUpdates.new_offer_email(recruit, team, fellow.email).deliver

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
