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
    if user.class.name == 'Fellow' && user.professor
    # if user.class.name == 'Fellow'
      # Get all students and there team
      # For each student, calculate equity
      students = Student.all
      studentsData = []
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

      render "mentor/csv.html.erb"
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

end
