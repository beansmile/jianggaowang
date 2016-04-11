class UserSignUpMailer < ActionMailer::Base
  default from: Rails.application.secrets.mail['admin']

  def notify_admin(new_user)
    @new_user = new_user

    mail to: @new_user.email
  end

  def admin_approved(user)
    @user = user
    mail to: @user.email
  end
end
