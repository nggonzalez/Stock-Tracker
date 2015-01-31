class API::ReportsController < ApplicationController

  def bug
    Reports.bug_email(request.POST['error'], request.POST['feedback'], get_user).deliver
    head :no_content
  end

end
