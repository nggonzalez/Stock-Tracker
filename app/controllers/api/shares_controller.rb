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
      singleShareData[:daysVested] = (Date.current - Time.at(share.created_at).to_date).to_i
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares / (due_date - Time.at(share.created_at).to_date).to_i
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
end

