class API::StudentsController < ApplicationController
  def show
    student = Student.where(netid: params[:id]).first
    if student
      render json: {student: student}, status: :ok
    else
      render json: {student: nil}, status: :not_found
    end
  end

  def index
    students = Student.includes(:teams).all
    render json: {students: students}, status: :ok
  end
end

