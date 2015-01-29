class API::QuestionsController < ApplicationController
  before_action :checkForFellow, only: [:update, :create, :delete]

  def index
    questions = Question.all || []
    render json: {faqs: questions}, status: :ok
  end

  def update
    updatedQ = request.POST['question']
    if Question.find(updatedQ.id).present?
      updatedQ.update!(question_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def create
    puts request.POST
    newQ = Question.new
    newQ.question = request.POST['text']
    newQ.answer = request.POST['answer']
    newQ.save!(question_params)
    head :no_content
  end

  def delete
    Question.delete!(params[:id])
    head :no_content
  end

  private

  def checkForFellow
    user = get_user
    if user.class.name != 'Fellow'
      render json: {}, status: :unauthorized
    end
  end

  def question_params
    params.require(:question).permit(:question, :answer)
  end

end
