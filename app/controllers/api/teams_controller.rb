class API::TeamsController < ApplicationController
  def show
    student = get_student
    studentEmployment = student.employees.includes(:team).load
    studentShares = Offer.where(signed: true, student_id: student.id).load
    companyData = {}
    companyData[:student] = student.firstname + ' ' + student.lastname
    companyData[:previousCompanies] = []

    studentEmployment.each do |company|
      shares = studentShares.select { |share| share.team_id == company.team_id }
      # studentShares.delete(shares)
      totalShares = 0
      earnedShares = 0
      shares.each do |offer|
        singleShareData = calculateEquityData(offer)
        totalShares += offer.shares
        earnedShares += singleShareData[:earnedShares]
      end

      if company.current
        companyCeo = Student.where(netid: company.team.ceo_id).select("CONCAT_WS(' ', firstname, lastname) as name").first.name
        companyEmployees = Team.find(company.team_id).students.where.not(id: student.id).select("id, CONCAT_WS(' ', firstname, lastname) as name").load
        companyData[:currentCompany] = {
          :companyId => company.team_id,
          :company => company.team.company_name,
          :ceo => companyCeo,
          :employees => companyEmployees,
          :totalShares => totalShares,
          :earnedShares => earnedShares
        }

        next
      end

      companyData[:previousCompanies].push({
        :company => company.team.company_name,
        :startDate => company.created_at,
        :endDate => company.updated_at,
        :totalShares => totalShares,
        :earnedShares => earnedShares
      })
    end

    render json: companyData
  end

  def shares
    team = Team.where(id: params[:team]).first
    render json: {shares: calculateDistributableShares(team)}, status: :ok
  end
end
