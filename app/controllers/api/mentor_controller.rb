class API::MentorController < ApplicationController
  def groups
    user = get_user
    if user && user.class.name == 'Fellow'
    # if user.class.name == 'Student'
      teams = user.teams
      groups = []
      teams.each do |team|
        group = {}
        group[:teamId] = team.id
        group[:name] = team.company_name
        group[:employees] = team.students.select("id, email, admin, CONCAT_WS(' ', firstname, lastname) as name").load
        groups.push(group)
      end
      puts groups
      render json: groups, status: :ok
    else
      render status: :unauthorized
    end
  end

  def prof
    user = get_user
    # if user.class.name == 'Fellow' && user.prof
    if user.class.name == 'Student'
      # Get all students and there team
      # For each student, calculate equity
      students = Student.all
      studentsData = []
      students.each do |student|
        studentData = {}
        studentData[:name] = student.firstname + ' ' + student.lastname
        studentData[:id] = student.id
        studentData[:netid] = student.netid
        if Employee.includes(:team).where(student_id: student.id, current: true).present?
          company = Employee.includes(:team).where(student_id: student.id, current: true).first
          studentData[:currentCompany] = company.team.company_name.truncate(20, separator: /\s|\:|\-/)
          studentData[:totalEquity] = 0
          studentData[:earnedEquity] = 0
          studentData[:dailyEquityIncrease] = 0
          # START OF COPIED
          shares = Offer.includes(:team).where(student_id: student.id, answered: true, signed: true).load
          shares.each do |share|
            daysVested = (Date.current - Time.at(share.date_signed).to_date).to_i
            studentData[:dailyEquityIncrease] += dailyIncrease = share.shares / (due_date - Time.at(share.date_signed).to_date).to_i
            studentData[:totalEquity] += share.shares
            studentData[:earnedEquity] += daysVested * dailyIncrease
          end
          studentsData.push(studentData);
        else
          puts student.netid
        end
        # END OF COPIED
      end
      render json: studentsData, status: :ok
    else
      render status: :unauthorized
    end
  end
end
