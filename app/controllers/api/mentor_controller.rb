class API::MentorController < ApplicationController
  def groups
    user = get_user
    if user && user.class.name == 'Fellow'
      teams = user.teams
      groups = []
      teams.each do |team|
        if(team.dissolved == true)
          next
        end
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
    if user.class.name == 'Fellow'
    # if user.class.name == 'Fellow'
      # Get all students and there team
      # For each student, calculate equity
      students = Student.order(investments_value: :desc).all
      studentsData = []
      rank = 1
      students.each do |student|
        if student.offers.empty?
          next
        end
        currentTeamId = getCurrentTeam(student.id)
        studentData = {}
        studentData[:name] = student.firstname + ' ' + student.lastname
        studentData[:id] = student.id
        studentData[:netid] = student.netid
        studentData[:investedDollars] = student.invested_dollars
        studentData[:investableDollars] = student.investable_dollars
        studentData[:investmentsValue] = student.investments_value
        studentData[:rank] = rank
        rank = rank + 1

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
    user = get_user
    if user.class.name != 'Fellow'
      render json: {}, status: :unauthorized
      return
    end

    student = Student.where(id: params[:student]).select("CONCAT_WS(' ', firstname, lastname) as name, id").first
    teams = student.teams.uniq
    sharesData = {}
    sharesData[:student] = student
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
      sharesData[:shares].push(teamData)
    end

    # puts sharesData
    render json: sharesData, status: :ok
  end


  def modifiableOffers
    team_id = params[:team]
    if Team.find(team_id).present?
      group = Team.find(team_id).company_name
      all_offers = Offer.includes(:student).where(team_id: team_id, signed: false).load
      open_offers = all_offers.select {|offer| offer.answered == false}.map{ |offer| prepare_modifiable_offer(offer)}
      rejected_offers = all_offers.select {|offer| offer.answered == true && offer.offer_date > 2.weeks.ago}.map{ |offer| prepare_modifiable_offer(offer) }

      render json: {group: group, open: open_offers, rejected: rejected_offers}, status: :ok
    end
  end


  def csvFile
    user = get_user
    if user.class.name == 'Fellow'
      students = Student.order(:lastname, :firstname).all
      @studentsData = []
      students.each do |student|
        if student.offers.empty?
          next
        end
        studentData = {}
        studentData[:firstname] = student.firstname
        studentData[:lastname] = student.lastname
        studentData[:netid] = student.netid
        studentData[:investmentsValue] = student.investments_value.round(4)
        studentData[:investedDollars] = student.invested_dollars.round(4)
        studentData[:investableDollars] = student.investable_dollars.round(4)



        currentTeamId = getCurrentTeam(student.id)
        studentData[:lastTeam] = Team.find(currentTeamId).company_name
        studentData[:teams] = []

        teams = student.teams.order(:company_name).uniq
        sharesData = {}
        sharesData[:aggregateTotalShares] = 0;
        sharesData[:aggregateEarnedShares] = 0
        sharesData[:dailyIncrease] = 0
        sharesData[:shares] = []

        teams.each do |team|
          teamData = {}
          teamData[:name] = team.company_name
          employeeJoinDates = Employee.where(student_id: student.id, team_id: team.id).load
          teamData[:joinDates] = []
          employeeJoinDates.each do |joinDate|
            teamData[:joinDates].push(joinDate.created_at)
          end
          teamData[:shares] = 0
          offers = Offer.where(student_id: student.id, team_id: team.id, signed: true).load
          offers.each do |offer|
            offerData = calculateEquityData(offer)
            sharesData[:dailyIncrease] += offerData[:dailyIncrease]
            sharesData[:aggregateEarnedShares] += offerData[:earnedShares]
            sharesData[:aggregateTotalShares] += offer.shares
            teamData[:shares] += offerData[:earnedShares]
          end
          sharesData[:shares].push(teamData)
        end
        studentData[:teams].push(sharesData)
        @studentsData.push(studentData)
        # END OF COPIED
      end

      allTeams = Team.order(:company_name).all
      @teams = []

      allTeams.each do |team|
        @teams.push(team.company_name)
      end

      send_data makeCSV(@teams, @studentsData),  :filename => 'cs113.csv'
    else
      render status: :unauthorized
    end
  end


private

def prepare_modifiable_offer(offer)
  o = {}
  o[:id] = offer.id
  o[:student] = offer.student.firstname + ' ' + offer.student.lastname
  o[:waitingPeriod] = ((offer.offer_date + 14.days).to_date - Date.current).to_i
  o[:shares] = offer.shares
  o[:offerDate] = offer.offer_date
  o[:daysSinceOffer] = (Date.current - (offer.offer_date).to_date).to_i
  return o
end

def makeCSV(teams, studentsData)
  csv = ""
  csv += "lastname, firstname, netid, finalTeam, totalEarned, totalOffered, investmentsValue, investedDollars, investableDollars,"

  teams.each do |team|
    csv += team +', JoinDate'
    if team != teams.last
      csv += ","
    end
  end
  csv+="\n"

  studentsData.each do |student|
    csv += student[:lastname] + "," + student[:firstname] + "," + student[:netid] + ","
    csv += student[:lastTeam] + "," + student[:investmentsValue].to_s + ","
    csv += student[:investedDollars].to_s + "," + student[:investableDollars].to_s + ","
    csv += student[:teams].first[:aggregateEarnedShares].to_s + "," + student[:teams].first[:aggregateTotalShares].to_s + ","
    teams.each do |team|
      if !student[:teams].first[:shares].empty?
        if team != student[:teams].first[:shares].first[:name]
          csv += "0, N/A"
        else
          csv += student[:teams].first[:shares].first[:shares].round(4).to_s + ","
          csv += "["
          student[:teams].first[:shares].first[:joinDates].each do |joinDate|
            csv += joinDate.to_s
            if joinDate != student[:teams].first[:shares].first[:joinDates].last
              csv += ","
            end
          end
          csv += "]"
          student[:teams].first[:shares].shift
        end
      else
        csv += "0, N/A"
      end
      if team != teams.last
        csv += ","
      end
    end
    csv += "\n"
  end
  csv
end

end
