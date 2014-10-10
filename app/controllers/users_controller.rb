class UsersController < ApplicationController
  def show
    @user = User.find params[:id]

    if current_user && current_user == @user
      redirect_to profile_path
    else
      @slides = @user.slides.page(params[:page])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "注册成功，您现在已登录"
      session[:user_id] = @user.id

      redirect_to root_path
    else
      flash[:warning] = "新用户注册失败"
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
