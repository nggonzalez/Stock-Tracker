class API::SharesController < ApplicationController
  def show
    student = get_student
    shares = Offer.includes(:team).where(student_id: student.id, answered: true, signed: true).all
    sharesData = {}
    sharesData[:aggregateTotalShares] = 0;
    sharesData[:aggregateEarnedShares] = 0
    sharesData[:dailyIncrease] = 0
    sharesData[:daysRemaining] = (due_date - Date.current).to_i;
    sharesData[:shares] = []
    sharesData[:formattedEquity] = []
    sharesData[:axisDates] = {:max=> due_date, :min => start_date}

    shares.each do |share|
      singleShareData = calculateEquityData(share)
      singleShareData[:formattedEquity] = {:key => share.team.company_name, :values => []}


      sharesData[:dailyIncrease] += singleShareData[:dailyIncrease]
      sharesData[:aggregateEarnedShares] += singleShareData[:earnedShares]
      sharesData[:aggregateTotalShares] += share.shares


      startingDate = Time.at(share.date_signed).to_date
      endDate = Time.at(share.end_date).to_date
      i = (startingDate - start_date).to_i;
      if i < 0
        i = 0
      end

      while startingDate < endDate
        singleShareData[:formattedEquity][:values].push([i, singleShareData[:dailyIncrease]*i])
        startingDate = startingDate + 1.day
        i = i + 1
      end
      sharesData[:formattedEquity].push(singleShareData[:formattedEquity])
      sharesData[:shares].push(singleShareData)
    end

    render json: sharesData, status: :ok
  end

  def employeeShares
    student = Student.where(id: params[:employee]).select("CONCAT_WS(' ', firstname, lastname) as name, id").first
    shares = Offer.where(student_id: student.id, team_id: params[:team], answered: true, signed: true).all
    lastOffer = Offer.where(student_id: student.id, team_id: params[:team]).last
    employee = {}
    employee[:employee] = student
    employee[:eligibleForOffer] = eligible_for_offer(lastOffer)
    sharesData = {}
    sharesData[:aggregateTotalShares] = 0;
    sharesData[:aggregateEarnedShares] = 0
    sharesData[:dailyIncrease] = 0
    sharesData[:daysRemaining] = (due_date - Date.current).to_i;
    sharesData[:shares] = []

    shares.each do |share|
      singleShareData = calculateEquityData(share)

      sharesData[:dailyIncrease] += singleShareData[:dailyIncrease]
      sharesData[:aggregateEarnedShares] += singleShareData[:earnedShares]
      sharesData[:aggregateTotalShares] += share.shares

      sharesData[:shares].push(singleShareData)
    end

    employee[:offers] = sharesData

    render json: employee, status: :ok
  end

end

