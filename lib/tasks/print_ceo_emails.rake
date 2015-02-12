namespace :print do
  desc 'Print ceo emails.'
  task :ceo_emails => :environment do
    students = Student.where(admin: true).all
    students.each do |student|
      print '<Mentor email="'
      print student.email
      print '" />'
      puts ""
    end

  end
end