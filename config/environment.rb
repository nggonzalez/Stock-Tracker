# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
StockTrader::Application.initialize!

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://secure.its.yale.edu/cas/",
  :username_session_key => :cas_user,
  :extra_attributes_session_key => :cas_extra_attributes
)

credentials = YAML.load_file("#{Rails.root}/config/credentials.yml")
ENV['SENDGRID_USERNAME'] = credentials['username']
ENV['SENDGRID_PASSWORD'] = credentials['password']

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => 'cs112stocktracker.herokuapp.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

