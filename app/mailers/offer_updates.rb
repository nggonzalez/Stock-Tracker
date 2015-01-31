class OfferUpdates < ActionMailer::Base
  default from: "cs112stocktracker@gmail.com"

  # Offer sent
  def new_offer_email(recruit, team, email)
    @recruit = recruit
    @team = team
    mail( :to => email,
    :subject => '[CPSC 113] New Offer' )
  end

  def offer_accepted_email(recruit, team, email)
    @recruit = recruit
    @team = team
    mail( :to => email,
    :subject => '[CPSC 113] Offer Accepted' )
  end

  def offer_rejected_email(recruit, team, email)
    @recruit = recruit
    @team = team
    mail( :to => email,
    :subject => '[CPSC 113] Offer Rejected' )
  end
end
