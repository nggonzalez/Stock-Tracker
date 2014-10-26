class API::SharesController < ApplicationController
  def show
    shares = Offer.includes(:team).where(student_id: session[:cas_user], signed: true).all
    sharesData = {}
    sharesData[:aggregateTotalShares] = 0;
    sharesData[:aggregateEarnedShares] = 0
    sharesData[:dailyIncrease] = 0
    sharesData[:daysRemaining] = (due_date - Date.current).to_i;
    sharesData[:shares] = []

    shares.each do |share|
      singleShareData = {}
      singleShareData[:cliffDate] = share.cliff_date
      singleShareData[:daysVested] = (Date.current - Time.at(share.created_at).to_date).to_i
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares / (due_date - Time.at(share.created_at).to_date).to_i
      singleShareData[:earnedShares] = singleShareData[:daysVested] * dailyShareIncrease
      singleShareData[:formattedEquity] = {:key => share.team_id , :values => []}

      sharesData[:dailyIncrease] += dailyShareIncrease
      sharesData[:aggregateEarnedShares] += singleShareData[:earnedShares]
      sharesData[:aggregateTotalShares] += share.shares


      startingDate = Time.at(share.created_at).to_date
      i = 1

      while startingDate < Date.current.tomorrow
        singleShareData[:formattedEquity][:values].push([startingDate.to_time.to_i, dailyShareIncrease*i])
        startingDate = startingDate.tomorrow
        i = i + 1
      end

      sharesData[:shares].push(singleShareData)
      # share.formattedEquity = formattedEquity
      # formattedEquity.each do |entry|
      #   print entry
      #   puts
      # end

      # share.each do |key, value|
      #   print key + ' ' + value
      #   puts
      # end
    end



    render json: sharesData, status: :ok
  end

  protected

  def due_date
    return Date.new(2014, 12, 17)
  end

end

