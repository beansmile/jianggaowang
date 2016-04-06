class SessionsController < ApplicationController
  before_action :redirect_if_user_logined, except: :destroy
  before_action :require_approved, only: :create

  def new
    @user = User.new
  end

  def create
    if login_user
      if login_user.authenticate(params[:user].try(:[], :password))
        flash[:success] = "登录成功"
        session[:user_id] = login_user.id

        redirect_to after_sign_in_path
      else
        flash[:warning] = "密码错误，请重新输入"
        render 'new'
      end
    else
      @user = User.new
      flash[:warning] = "用户名不存在，请重新确认您的输入"
      render 'new'
    end
  end

  def destroy
    if current_user
      session[:user_id] = nil
      flash[:information] = "您已退出登录"
    else
      flash[:warning] = '您还没有登录，退出登录操作无效'
    end

    redirect_to root_path
  end

  private

  def redirect_if_user_logined
    if current_user
      flash[:warning] = '您已登录'
      return redirect_to root_path
    end

    true
  end

  def login_user
    @user ||= User.find_by name: params[:user].try(:[], :name)
  end

  def require_approved
    unless login_user.try(:approved_at)
      flash[:error] = "管理员还没有通过您的注册申请，请在收到申请通过邮件后再登录"
      return redirect_to root_path
    end
  end
end
