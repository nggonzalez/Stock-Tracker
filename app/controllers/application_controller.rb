class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Add this before filter to force CAS Authentication on all controllers + actions
  protect_from_forgery with: :null_session
  before_filter CASClient::Frameworks::Rails::Filter, :unless => :skip_login?

  # Add this before filter to set a local variable for the current user from CAS session
  before_filter :get_student
  after_filter :set_csrf_cookie_for_ng


  # And their protected methods
  protected

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def get_student
    me = Student.where(netid: session[:cas_user]).first
    if !me
      redirect_to :root
      return false
    end

    return me
  end

  # hack for skip_before_filter with CAS
  # overwrite this method (with 'true') in any controller you want to skip CAS authentication
  def skip_login?
    false
  end

  protected

  def due_date
    return Date.new(2014, 12, 17)
  end

  def start_date
    return Date.new(2014, 10, 27)
  end

end
