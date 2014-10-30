class API::StudentsController < ApplicationController
  def show
    student = Student.where(netid: session[:cas_user]).first
    if student
      render json: {student: student}, status: :ok
    else
      render json: {student: nil}, status: :not_found
    end
  end

  def index
    students = Student.where(admin: true).select('name, id').load
    render json: {students: students}, status: :ok
  end
end

