class API::QuestionsController < ApplicationController
  before_action :checkForFellow, only: [:update, :create, :delete]

  def index
    questions = Question.all || []
    render json: {faqs: questions}, status: :ok
  end

  def update
    if Question.find(request.POST['id']).present?
      question = Question.find(request.POST['id'])
      question.question = request['question']
      question.answer = request['answer']
      question.save!
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def create
    newQ = Question.new
    newQ.question = request.POST['question']
    newQ.answer = request.POST['answer']
    newQ.save!
    render json: newQ, status: :created
  end

  def delete
    if Question.find(params[:id]).present?
      Question.delete(params[:id])
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def checkForFellow
    # render json: {}, status: :unauthorized
    user = get_user
    if user.class.name != 'Fellow'
      render json: {}, status: :unauthorized
    end
  end

  def question_params
    params.require(:question).permit(:question, :answer)
  end

end
