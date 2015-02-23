class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Add this before filter to force CAS Authentication on all controllers + actions
  protect_from_forgery with: :null_session
  before_filter CASClient::Frameworks::Rails::Filter, :unless => :skip_login?

  # Add this before filter to set a local variable for the current user from CAS session
  before_filter :get_user
  after_filter :set_csrf_cookie_for_ng


  # And their protected methods
  protected

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def get_user
    # @user = get_fellow || get_student
    @user = get_student
    if !@user
      redirect_to :root
      return false
    end
    return @user
  end

  def get_fellow
    if Fellow.where(netid: session[:cas_user]).present?
      me = Fellow.where(netid: session[:cas_user]).first
      return me
    end
    nil
  end

  def get_student
    if Student.where(netid: session[:cas_user]).present?
      me = Student.where(netid: session[:cas_user]).first
      return me
    end
    nil
  end

  def mentor_check
    user = get_user
    render json: {}, status: :unauthorized unless user.class.name == "Fellow"
  end

  # hack for skip_before_filter with CAS
  # overwrite this method (with 'true') in any controller you want to skip CAS authentication
  def skip_login?
    false
  end

  def due_date
    return Date.new(2015, 4, 30)
  end

  def start_date
    return Date.new(2015, 2, 12)
  end

  def eligible_for_offer(lastOffer)
    offerTimeDelta = (Date.current - Time.at(lastOffer.offer_date).to_date).to_i
    if lastOffer.expired && offerTimeDelta < 14
      false
    elsif lastOffer.answered
      if lastOffer.signed || offerTimeDelta > 14
        true
      else
        false
      end
    elsif offerTimeDelta < 14
      false
    else
      true
    end
  end


  def calculateDistributableShares(team)
    return team.total_shares - team.shares_distributed - team.held_shares
  end


  def getCurrentTeam(student_id)
    offer = Offer.where(student_id: student_id, signed: true).last
    return offer.team_id
  end


  def getTeamEmployees(team_id, student_id=-1)
    employees = []
    teamOffers = Offer.includes(:student).where(team_id: team_id, signed: true).where.not(student_id: student_id).load
    teamOffers.each do |offer|
      if offer.end_date.to_date != due_date.to_date
        next
      end

      employees.push(offer.student)
    end
    return employees.uniq
  end


  def calculateEquityData(share)
    singleShareData = {}
    singleShareData[:offerDate] = share.created_at
    singleShareData[:company] = share.team.company_name
    singleShareData[:cliffDate] = share.cliff_date
    singleShareData[:dailyIncrease] = 0
    singleShareData[:totalShares] = share.shares
    singleShareData[:earnedShares] = 0

    if Date.current < due_date
      if share.end_date.to_date == due_date
        singleShareData[:daysVested] = (Date.current - Time.at(share.date_signed).to_date).to_i
      elsif share.end_date.to_date < share.cliff_date.to_date
        return singleShareData
      else
        singleShareData[:daysVested] = (Time.at(share.end_date).to_date - Time.at(share.date_signed).to_date).to_i
      end
    else
      if share.end_date.to_date == due_date
        singleShareData[:daysVested] = (due_date - Time.at(share.date_signed).to_date).to_i
      elsif share.end_date.to_date < share.cliff_date.to_date
        return singleShareData
      else
        singleShareData[:daysVested] = (Time.at(share.end_date).to_date - Time.at(share.date_signed).to_date).to_i
      end
    end

    if Time.at(share.offer_date).to_date < due_date && Time.at(share.date_signed).to_date < due_date
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares.to_f / ((due_date - Time.at(share.date_signed).to_date).to_i)
    else
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares.to_f
    end

    if Time.at(share.offer_date).to_date < due_date && Time.at(share.date_signed).to_date < due_date
      singleShareData[:earnedShares] = (singleShareData[:daysVested] * dailyShareIncrease)
    elsif Time.at(share.offer_date).to_date >= due_date || Time.at(share.date_signed).to_date >= due_date
      singleShareData[:earnedShares] = share.shares
    end

    singleShareData[:dailyIncrease] = dailyShareIncrease

    return singleShareData
  end

  def calculateTeamInvestmentsValue(student_id, team_id, round, round_value)
    investmentData = {}
    investmentData[:round] = round
    investmentData[:sharePrice] = round_value
    investmentData[:team_id] = team_id
    investmentData[:company_name] = Team.where(id: team_id).first.company_name
    investmentData[:dollarValue] = 0
    investments = Investment.where(student_id: student_id, team_id: team_id).where("round <= #{round}").load
    investments.each do |investment|
      investmentData[:dollarValue] += investment.shares * round_value
    end
    investmentData
  end

  def calculateAllInvestmentsValue(student_id)
    currentTeam = getCurrentTeam(student_id)
    teams = Team.all
    round = Valuation.where(live: true).maximum("valuation_round")
    investmentsValue = 0
    teams.each do |team|
      round_value = Valuation.where(team_id: team.id, valuation_round: round).first.value
      investmentsValue += calculateTeamInvestmentsValue(student_id, team.id, round, round_value)[:dollarValue]
    end
    investmentsValue
  end

end
