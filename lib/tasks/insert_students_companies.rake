
namespace :insert do
  desc 'Insert students and companies into the database.'
  task :students_teams => :environment do
    doc = Nokogiri::XML(File.open("#{Rails.root}/db/result.xml"))
    doc.root.elements.each do |node|
      if node.node_name.eql? 'Student'
        s = Student.new
        s.firstname = node.attr('firstname').to_s
        s.lastname = node.attr('lastname').to_s
        s.email = node.attr('email').to_s
        s.netid = node.attr('netid').to_s
        s.save!

      elsif node.node_name.eql? 'Team'
        employees = node.children
        if employees.empty?
          next
        end

        t = Team.new
        t.company_name = node.attr('name').to_s
        t.ceo_id = node.attr('ceonetid').to_s
        t.total_shares = 0
        t.held_shares = 0
        t.shares_distributed = 0
        t.save!

        ceo = Student.where(netid: node.attr('ceonetid').to_s).first
        ceo.admin = true
        ceo.save!

        startDate = Date.new(2014, 10, 27)
        ceoOffer = Offer.new
        ceoOffer.shares = 1000000
        ceoOffer.answered = true
        ceoOffer.signed = true
        ceoOffer.student_id = ceo.id
        ceoOffer.team_id = t.id
        ceoOffer.offer_date = startDate
        ceoOffer.cliff_date = startDate
        ceoOffer.created_at = startDate
        ceoOffer.date_signed = startDate
        ceoOffer.end_date = Date.new(2014, 12, 11)
        ceoOffer.save!

        e = Employee.new
        e.team_id = t.id
        e.current = true
        e.student_id = ceo.id
        e.save!

        employees.each do |employee|
          employeeData = Student.where(netid: employee.attr('netid').to_s).first
          e = Employee.new
          e.team_id = t.id
          e.current = true
          e.student_id = employeeData.id
          e.save!

          o = Offer.new
          o.shares = 300000
          o.cliff_date = startDate + 14.days
          o.offer_date = startDate
          o.created_at = startDate
          o.answered = true
          o.signed = true
          o.date_signed = startDate
          o.end_date = Date.new(2014, 12, 11)
          o.student_id = employeeData.id
          o.team_id = t.id
          o.save!
        end
      end
    end
  end
end