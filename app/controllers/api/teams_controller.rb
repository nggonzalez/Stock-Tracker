class API::TeamsController < ApplicationController
  def show
    student = Student.where(netid: session[:cas_user]).first
    studentEmployment = student.employees.includes(:team).all
    studentShares = Offer.where(signed: true, student_id: student.id).all
    companyData = {}
    companyData[:student] = student.name
    companyData[:previousCompanies] = []

    studentEmployment.each do |company|
      shares = studentShares.select { |share| share.team_id == company.team_id }
      studentShares.delete(shares)
      totalShares = 0
      earnedShares = 0
      shares.each do |offer|
        daysVested = (Date.current - Time.at(offer.created_at).to_date).to_i
        dailyIncrease = offer.shares / (due_date - Time.at(offer.created_at).to_date).to_i
        totalShares += offer.shares
        if company.current
          earnedShares += dailyIncrease * daysVested
        elsif company.updated_at >= offer.cliff_date
          daysVested = (Time.at(offer.updated_at).to_date - Time.at(offer.created_at).to_date).to_i
          earnedShares += dailyIncrease * daysVested
        end
      end

      if company.current
        companyCeo = Student.where(netid: company.team.ceo_id).select('name').first.name
        companyEmployees = Team.find(company.team_id).students.where.not(id: student.id).select('students.name')
        companyData[:currentCompany] = {
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
end
