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
      singleShareData = {}
      singleShareData[:offerDate] = share.created_at
      singleShareData[:company] = share.team.company_name
      singleShareData[:cliffDate] = share.cliff_date
      singleShareData[:daysVested] = (Date.current - Time.at(share.offer_date).to_date).to_i
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares / (due_date - Time.at(share.offer_date).to_date).to_i
      singleShareData[:totalShares] = share.shares
      singleShareData[:earnedShares] = singleShareData[:daysVested] * dailyShareIncrease
      singleShareData[:formattedEquity] = {:key => share.team.company_name, :values => []}

      sharesData[:dailyIncrease] += dailyShareIncrease
      sharesData[:aggregateEarnedShares] += singleShareData[:earnedShares]
      sharesData[:aggregateTotalShares] += share.shares


      startingDate = share.created_at
      i = 1

      while Time.at(startingDate).to_date < Date.current.tomorrow
        singleShareData[:formattedEquity][:values].push([startingDate, dailyShareIncrease*i])
        startingDate = startingDate + 1.day
        i = i + 1
      end
      sharesData[:formattedEquity].push(singleShareData[:formattedEquity])
      sharesData[:shares].push(singleShareData)
    end

    render json: sharesData, status: :ok
  end

  def employeeShares
    student = Student.where(id: params[:employee]).select('name, id').first
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
      singleShareData = {}
      singleShareData[:offerDate] = share.created_at
      singleShareData[:company] = share.team.company_name
      singleShareData[:cliffDate] = share.cliff_date
      singleShareData[:daysVested] = (Date.current - Time.at(share.offer_date).to_date).to_i
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares / (due_date - Time.at(share.offer_date).to_date).to_i
      singleShareData[:totalShares] = share.shares
      singleShareData[:earnedShares] = singleShareData[:daysVested] * dailyShareIncrease

      sharesData[:dailyIncrease] += dailyShareIncrease
      sharesData[:aggregateEarnedShares] += singleShareData[:earnedShares]
      sharesData[:aggregateTotalShares] += share.shares

      sharesData[:shares].push(singleShareData)
    end

    employee[:offers] = sharesData

    render json: employee, status: :ok
  end


  private

  def eligible_for_offer(lastOffer)
    offerTimeDelta = (Date.current - Time.at(lastOffer.offer_date).to_date).to_i
    if lastOffer.answered
      if lastOffer.signed || offerTimeDelta > 14
        true
      else
        false
      end
    elsif offerTimeDelta > 2 && offerDate < 14
      false
    else
      true
    end
  end

end

