class Reports < ActionMailer::Base
  default from: "cs112stocktracker@gmail.com"

  # Offer sent
  def bug_email(error_details, user_feedback, user)
    @user = user
    @error_details = error_details
    @user_feedback = user_feedback
    mail( :to => webmaster_email,
    :subject => '[CPSC 113] Error Report' )
  end

  private

  def webmaster_email
    return "nicholas.gonzalez@yale.edu"
  end
end
