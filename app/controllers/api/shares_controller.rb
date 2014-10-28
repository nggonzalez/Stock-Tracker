class API::SharesController < ApplicationController
  def index
    shares = Offer.includes(:team).where(student_id: session[:cas_user], signed: true).all
    sharesData = {}
    sharesData[:aggregateTotalShares] = 0;
    sharesData[:aggregateEarnedShares] = 0
    sharesData[:dailyIncrease] = 0
    sharesData[:daysRemaining] = (due_date - Date.current).to_i;
    sharesData[:shares] = []
    sharesData[:formattedEquity] = []

    shares.each do |share|
      singleShareData = {}
      singleShareData[:offerDate] = share.created_at
      singleShareData[:company] = share.team_id
      singleShareData[:cliffDate] = share.created_at + 14.days
      singleShareData[:daysVested] = (Date.current - Time.at(share.created_at).to_date).to_i
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares / (due_date - Time.at(share.created_at).to_date).to_i
      singleShareData[:totalShares] = share.shares
      singleShareData[:earnedShares] = singleShareData[:daysVested] * dailyShareIncrease
      singleShareData[:formattedEquity] = {:key => "Company #{share.team_id}", :values => []}

      sharesData[:dailyIncrease] += dailyShareIncrease
      sharesData[:aggregateEarnedShares] += singleShareData[:earnedShares]
      sharesData[:aggregateTotalShares] += share.shares


      startingDate = Time.at(share.created_at).to_date
      i = 1

      while startingDate < Date.current.tomorrow
        singleShareData[:formattedEquity][:values].push([startingDate.strftime('%Y-%m-%d %H:%M:%S'), dailyShareIncrease*i])
        startingDate = startingDate.tomorrow
        i = i + 1
      end
      sharesData[:formattedEquity].push(singleShareData[:formattedEquity])
      sharesData[:shares].push(singleShareData)
    end



    render json: sharesData, status: :ok
  end

  protected

  def due_date
    return Date.new(2014, 12, 17)
  end

end

