
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
      elsif node.node_name.eql? 'Team'
        employees = node.children
        if !employees.empty?
          puts node
        else
          next
        end
        t = Team.new
        t.company_name = node.attr('name').to_s
        t.ceo_id = node.attr('ceonetid').to_s
        t.total_shares = 0
        t.held_shares = 0
        t.shares_distributed = 0


      end
    end
  end
end