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
    @user = get_fellow || get_student
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

  # hack for skip_before_filter with CAS
  # overwrite this method (with 'true') in any controller you want to skip CAS authentication
  def skip_login?
    false
  end

  def due_date
    return Date.new(2014, 12, 11)
  end

  def start_date
    return Date.new(2014, 10, 27)
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


  def calculateEquityData(share)
    singleShareData = {}
    singleShareData[:offerDate] = share.created_at
    singleShareData[:company] = share.team.company_name
    singleShareData[:cliffDate] = share.cliff_date
    singleShareData[:dailyIncrease] = 0
    singleShareData[:totalShares] = share.shares
    singleShareData[:earnedShares] = 0
    puts share.end_date
    puts due_date
    if Time.at(share.end_date).to_date == due_date
      singleShareData[:daysVested] = (Date.current - Time.at(share.date_signed).to_date).to_i
    elsif Time.at(share.end_date).to_date < due_date
      return singleShareData
    else
      singleShareData[:daysVested] = (Time.at(share.end_date).to_date - Time.at(share.date_signed).to_date).to_i
    end
    singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares / (due_date - Time.at(share.offer_date).to_date).to_i
    singleShareData[:totalShares] = share.shares
    singleShareData[:earnedShares] = singleShareData[:daysVested] * dailyShareIncrease

    return singleShareData
  end

end
