namespace :delete do
  desc 'Add last 800,000 in shares for each team.'
  task :everything => :environment do
    Student.delete_all
    Employee.delete_all
    Team.delete_all
    Offer.delete_all
    Mentor.delete_all
    Fellow.delete_all
    Investment.delete_all
    Valuation.delete_all
    Question.delete_all
  end
end