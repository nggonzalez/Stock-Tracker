class MainController < ApplicationController
  def index
    true
  end

  def logout
    session[:user_id] = nil
    session[:cas_user] = nil
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
