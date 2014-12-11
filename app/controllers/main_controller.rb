class MainController < ApplicationController
  def index
    user = get_user
    current_uri = request.env['PATH_INFO']
    if user.class.name == 'Fellow'
      puts user.professor
      puts current_uri
      if user.professor && current_uri != '/mentor/prof'
        redirect_to :prof_view
      elsif !user.professor && current_uri != '/mentor/groups'
       redirect_to :mentor_groups
      end
    elsif user.class.name == 'Student' && (current_uri == '/mentor/prof' || current_uri == '/mentor/groups')
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
