class API::TeamsController < ApplicationController
  before_action :mentor_check, only: [:dissolve]


  def show
    student = get_student
    currentCompanyId = getCurrentTeam(student.id)
    studentEmployment = student.teams.load

    companyData = {}
    companyData[:student] = student.firstname + ' ' + student.lastname
    companyData[:previousCompanies] = []

    if !student.admin
      studentShares = Offer.where(signed: true, student_id: student.id).load
      studentEmployment.each do |company|
        shares = studentShares.select { |share| share.team_id == company.id }
        totalShares = 0
        earnedShares = 0
        startDate = nil
        endDate = nil
        shares.each do |offer|
          if startDate == nil
            startDate = offer.created_at.to_date
          elsif startDate > offer.created_at.to_date
            startDate = offer.created_at.to_date
          end

          if endDate == nil
            endDate = offer.end_date.to_date
          elsif endDate < offer.end_date.to_date
            endDate = offer.end_date.to_date
          end

          singleShareData = calculateEquityData(offer)
          totalShares += offer.shares
          earnedShares += singleShareData[:earnedShares]
        end

        if currentCompanyId == company.id
          companyCeo = Student.where(netid: company.ceo_id).select("CONCAT_WS(' ', firstname, lastname) as name").first.name
          companyEmployees = getTeamEmployees(currentCompanyId, student.id);
          companyData[:currentCompany] = {
            :companyId => currentCompanyId,
            :company => company.company_name,
            :ceo => companyCeo,
            :employees => companyEmployees,
            :totalShares => totalShares,
            :earnedShares => earnedShares
          }

          next
        end

        companyData[:previousCompanies].push({
          :company => company.company_name,
          :startDate => startDate,
          :endDate => endDate,
          :totalShares => totalShares,
          :earnedShares => earnedShares
        })
      end
    else
      team = studentEmployment.first;
      companyCeo = Student.where(netid: team.ceo_id).select("CONCAT_WS(' ', firstname, lastname) as name").first.name
      companyEmployees = getTeamEmployees(currentCompanyId, student.id);
      companyData[:currentCompany] = {
        :companyId => currentCompanyId,
        :company => team.company_name,
        :ceo => companyCeo,
        :employees => companyEmployees,
        :totalShares => team.total_shares,
        :distributedShares => team.shares_distributed,
        :heldShares => team.held_shares,
        :sharesToGive => team.total_shares - team.shares_distributed - team.held_shares
      }
    end

    render json: companyData
  end

  def shares
    team = Team.where(id: params[:team]).first
    render json: {shares: calculateDistributableShares(team)}, status: :ok
  end

  def dissolve
    team = Team.where(id: params[:team]).first
    team.dissolved = true
    team.save!
    head :no_content
  end
end
