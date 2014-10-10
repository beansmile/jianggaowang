class UserPasswordsController < ApplicationController
  before_action :check_authenticated_user
  before_action :check_user, :check_reset_password_token, only: [:edit, :update]

  def reset
  end

  def create_new
    username = params[:user][:name]
    user = User.find_by name: username

    if user
      user.generate_reset_password_token
      UserPasswordMailer.delay.reset_password(user)

      flash[:success] = "重置密码请求成功，我们已经给您发送了用于重置密码的邮件，请注意查收邮件！"
      redirect_to root_path
    else
      flash[:warning] = "用户名不存在，请重新输入"
      render 'reset'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes params[:user].permit(:password)
      @user.clear_reset_password_token
      flash[:success] = "密码重置成功！"

      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:warning] = "密码重置失败，原因：#{@user.errors.full_messages.join(', ')}"
      render 'edit'
    end
  end

  private
  def check_authenticated_user
    if current_user
      redirect_to root_path
      false
    end
  end

  def check_user
    @user = User.find_by id: params[:id]

    unless @user
      flash[:warning] = "用户不存在"
      redirect_to root_path
      false
    end

    true
  end

  def check_reset_password_token
    if @user.reset_password_token.nil? ||
      @user.reset_password_token != params[:reset_password_token] ||
      @user.reset_password_token_expires_at.nil? ||
      @user.reset_password_token_expires_at.past?
      flash[:warning] = "请求错误或过期失效，请重新操作！"
      redirect_to root_path
    end
  end
end
