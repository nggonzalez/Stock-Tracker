class MainController < ApplicationController
  def index
    user = get_user
    current_uri = request.env['PATH_INFO']
    if user.class.name == 'Fellow'
      if user.professor && (!current_uri.include? "mentor")
        redirect_to :prof_view
      elsif !user.professor && (!current_uri.include? "mentor")
       redirect_to :mentor_groups
      end
    elsif user.class.name == 'Student' && (current_uri.include? "mentor")
      redirect_to :home
    end
    true
  end

  def logout
    session[:user_id] = nil
    session[:cas_user] = nil
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
