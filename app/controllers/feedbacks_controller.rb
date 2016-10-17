class FeedbacksController < ApplicationController
  before_action :load_feedback

  def new
  end

  def create
    if @feedback.save
      flash[:success] = "您的意见或建议我们已经收到，非常感谢您对我们工作的大力支持！"
      redirect_to root_path
    else
      flash.now[:error] = @feedback.errors.full_messages.join(';')
      render 'new'
    end
  end

  private
  def load_feedback
    @feedback = Feedback.new(feedback_params)
  end

  def feedback_params
    params[:feedback].try(:permit, :email, :name, :title, :content)
  end
end
