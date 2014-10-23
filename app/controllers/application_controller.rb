class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Add this before filter to force CAS Authentication on all controllers + actions
  before_filter CASClient::Frameworks::Rails::Filter, :unless => :skip_login?
   
  # Add this before filter to set a local variable for the current user from CAS session
  before_filter :getMe
   
   
  # And their protected methods
  protected
   
  def getMe
    # @me = User.find_or_create_by_netid( session[:cas_user] )
    # if !@me
    #   redirect_to :root
    #   return false
    # end
    true
  end
   
  # hack for skip_before_filter with CAS
  # overwrite this method (with 'true') in any controller you want to skip CAS authentication
  def skip_login? 
    false 
  end

  protect_from_forgery with: :null_session
end
