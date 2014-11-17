class API::MentorController < ApplicationController
  def groups
    user = get_user
    if user && user.class.name == 'Fellow'
      teams = user.teams
      groups = []
      teams.each do |team|
        group = {}
        group[:teamId] = team.id
        group[:name] = team.company_name
        group[:employees] = getTeamEmployees(team.id)
        groups.push(group)
      end
      render json: groups, status: :ok
    else
      render status: :unauthorized
    end
  end

  def prof
    user = get_user
    if user.class.name == 'Fellow' && user.prof
    # if user.class.name == 'Fellow'
      # Get all students and there team
      # For each student, calculate equity
      students = Student.all
      studentsData = []
      students.each do |student|
        currentTeamId = getCurrentTeam(student.id)
        studentData = {}
        studentData[:name] = student.firstname + ' ' + student.lastname
        studentData[:id] = student.id
        studentData[:netid] = student.netid

        company = Team.where(id: currentTeamId).first
        studentData[:currentCompany] = company.company_name.truncate(20, separator: /\s|\:|\-/)
        studentData[:totalEquity] = 0
        studentData[:earnedEquity] = 0
        studentData[:dailyEquityIncrease] = 0
        # START OF COPIED
        shares = Offer.where(student_id: student.id, answered: true, signed: true).load
        shares.each do |share|
          singleShareData = calculateEquityData(share)
          studentData[:dailyEquityIncrease] += singleShareData[:dailyIncrease]
          studentData[:totalEquity] += share.shares
          studentData[:earnedEquity] += singleShareData[:earnedShares]
        end
        studentsData.push(studentData);

        # END OF COPIED
      end
      render json: studentsData, status: :ok
    else
      render status: :unauthorized
    end
  end

  def studentShares
    if user.class.name != 'Fellow'
      render json: {}, status: :unauthorized
      return
    end

    student = Student.where(id: params[:student]).select("CONCAT_WS(' ', firstname, lastname) as name, id").first
    teams = student.teams
    sharesData = {}
    sharesData[:aggregateTotalShares] = 0;
    sharesData[:aggregateEarnedShares] = 0
    sharesData[:dailyIncrease] = 0
    sharesData[:shares] = []

    teams.each do |team|
      teamData = {}
      teamData[:name] = team.company_name
      teamData[:shares] = []
      offers = Offer.where(student_id: student.id, team_id: team.id, signed: true).load
      offers.each do |offer|
        offerData = calculateEquityData(offer)
        sharesData[:dailyIncrease] += offerData[:dailyIncrease]
        sharesData[:aggregateEarnedShares] += offerData[:earnedShares]
        sharesData[:aggregateTotalShares] += offer.shares
        teamData[:shares].push(offerData)
      end
      sharesData[:shares].push(offerData)
    end

    render json: sharesData, status: :ok
  end

end
