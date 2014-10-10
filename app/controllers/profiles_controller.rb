class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_password, only: [:update]

  def show
    @slides = current_user.slides.page(params[:page]).per(params[:per_page])
  end

  def edit
  end

  def update
    if current_user.update_attributes permitted_user_params
      flash[:success] = "您的资料更新成功"
      redirect_to profile_path
    else
      flash[:danger] = "您的资料更新失败,原因:#{current_user.errors.full_messages.join('，')}"
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
      render 'edit' and return false
    end
  end
end
