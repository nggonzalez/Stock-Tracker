
namespace :fix do
  desc 'Fix boolean flag marking answered offers.'
  task :mistake_acceptance => :environment do
    student = Student.where(email: 'minhtri.pham@yale.edu').first
    offers = student.offers
    mistake = offers.last
    if mistake.team_id != 154
      return
    end

    wrongTeam = Team.where(id: mistake.team_id).first
    wrongTeam.shares_distributed -= mistake.shares
    wrongTeam.save!

    mistake.delete

    offers =  Student.where(email: 'minhtri.pham@yale.edu').first.offers
    oldTeam = Team.where(id: 149).first

    offers.each do |oldOffer|
      offerData = calculateEquityData(oldOffer)
      oldTeam.shares_distributed += (offerData[:totalShares] - offerData[:earnedShares])
      oldTeam.save!
      oldOffer.end_date = due_date
      oldOffer.save!
    end
  end

  def due_date
    return Date.new(2015, 4, 30)
  end

  def calculateEquityData(share)
    singleShareData = {}
    singleShareData[:offerDate] = share.created_at
    singleShareData[:company] = share.team.company_name
    singleShareData[:cliffDate] = share.cliff_date
    singleShareData[:dailyIncrease] = 0
    singleShareData[:totalShares] = share.shares
    singleShareData[:earnedShares] = 0

    if Date.current < due_date
      if share.end_date.to_date == due_date
        singleShareData[:daysVested] = (Date.current - Time.at(share.date_signed).to_date).to_i
      elsif share.end_date.to_date < share.cliff_date.to_date
        return singleShareData
      else
        singleShareData[:daysVested] = (Time.at(share.end_date).to_date - Time.at(share.date_signed).to_date).to_i
      end
    else
      if share.end_date.to_date == due_date
        singleShareData[:daysVested] = (due_date - Time.at(share.date_signed).to_date).to_i
      elsif share.end_date.to_date < share.cliff_date.to_date
        return singleShareData
      else
        singleShareData[:daysVested] = (Time.at(share.end_date).to_date - Time.at(share.date_signed).to_date).to_i
      end
    end

    if Time.at(share.offer_date).to_date < due_date && Time.at(share.date_signed).to_date < due_date
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares.to_f / ((due_date - Time.at(share.date_signed).to_date).to_i)
    else
      singleShareData[:dailyIncrease] = dailyShareIncrease = share.shares.to_f
    end

    if Time.at(share.offer_date).to_date < due_date && Time.at(share.date_signed).to_date < due_date
      singleShareData[:earnedShares] = (singleShareData[:daysVested] * dailyShareIncrease)
    elsif Time.at(share.offer_date).to_date >= due_date || Time.at(share.date_signed).to_date >= due_date
      singleShareData[:earnedShares] = share.shares
    end

    singleShareData[:dailyIncrease] = dailyShareIncrease

    return singleShareData
  end
end