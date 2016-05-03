class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_password, only: [:update]
  PROFILESPAGE_DEMO_COUNT = 8

  def show
    @events = current_user.events.newest.limit(PROFILESPAGE_DEMO_COUNT)
    @slides = current_user.slides.newest.limit(PROFILESPAGE_DEMO_COUNT)
  end

  def edit
    @user = current_user
  end

  def events
    @events = current_user.events.newest.page(params[:page])
  end

  def slides
    @slides = current_user.slides.newest.page(params[:page])
  end

  def update
    if current_user.update_attributes permitted_user_params
      flash[:success] = "您的资料更新成功"
      redirect_to :back
    else
      flash[:danger] = "您的资料更新失败,原因:#{current_user.errors.full_messages.join('，')}"
      @user = current_user
      render 'edit'
    end
  end

  private
  def permitted_user_params
    params.require(:user).permit(:email, :bio, :avatar, :original_password, :password, :password_confirmation)
  end

  def check_password
    user_params = params[:user]
    if user_params[:password].blank?
      user_params.delete :password
      user_params.delete :password_confirmation
      return true
    end

    unless current_user.authenticate(user_params[:original_password])
      flash[:danger] = "更新失败，请提供正确的旧密码"
      redirect_to :back and return false
    end
  end
end
