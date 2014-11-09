
namespace :insert do
  desc 'Insert fellows and mentors into the database.'
  task :mentors => :environment do
    doc = Nokogiri::XML(File.open("#{Rails.root}/db/mentor.xml")) do |config|
      config.strict.noblanks
    end
    doc.root.elements.each do |node|
      if node.node_name.eql? 'Professor'
        s = Fellow.new
        s.firstname = node.attr('firstname').to_s
        s.lastname = node.attr('lastname').to_s
        s.email = node.attr('email').to_s
        s.netid = node.attr('netid').to_s
        s.professor = true
        s.save!

      elsif node.node_name.eql? 'Fellow'
        groups = node.children

        s = Fellow.new
        s.firstname = node.attr('firstname').to_s
        s.lastname = node.attr('lastname').to_s
        s.email = node.attr('email').to_s
        s.netid = node.attr('netid').to_s
        s.save!

        groups.each do |group|
          # get student
          ceo = Student.where(email: group.attr('email').to_s).first
          team = Team.where(ceo_id: ceo.netid).first

          m = Mentor.new
          m.team_id = team.id
          m.fellow_id = s.id
          m.save!
        end
      end
    end
  end
end