class API::StudentsController < ApplicationController
  before_action :mentor_check, only: [:drop]

  def show
    student = Student.where(netid: session[:cas_user]).first
    if student
      render json: {student: student}, status: :ok
    else
      render json: {student: nil}, status: :not_found
    end
  end

  def index
    students = Student.where(admin: false).select("CONCAT_WS(' ', firstname, lastname) as name, id").load
    render json: {students: students}, status: :ok
  end

  def drop
    student = Student.find(params[:id])
    team = Team.find(getCurrentTeam(student.id))
    offers = Offer.where(student_id: student.id, team_id: team.id, end_date: Time.new(2015, 4, 30)).load
    offers.each do |offer|
      offerData = calculateEquityData(offer)
      if Date.current < offer.cliff_date
        offerData[:earnedShares] = 0
      end
      team.shares_distributed -= (offerData[:totalShares] - offerData[:earnedShares])
      team.save!
    end
    Offer.where(student_id: student.id).destroy_all
    student = Student.destroy(student)
    head :no_content
  end
end

