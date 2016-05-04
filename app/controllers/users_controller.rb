class UsersController < ApplicationController
  before_action :redirect_if_user_logined, except: :show

  def show
    @user = User.find params[:id]

    if current_user && current_user == @user
      redirect_to profile_path
    else
      @slides = @user.slides.order(created_at: :desc).page(params[:page])
    end
  end

  def new
    @user = User.new

    render :new, layout: 'sign_in_up'
  end

  def create
    @user = User.new user_params
    if @user.save
      UserSignUpMailer.delay.notify_admin(@user)

      flash[:success] = "注册成功，请等候管理员的审核"
      redirect_to root_path
    else
      flash[:warning] = "新用户注册失败"
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation, :bio
    )
  end

  def redirect_if_user_logined
    if current_user
      flash[:warning] = '您已登录'
      redirect_to root_path
    end
  end
end
