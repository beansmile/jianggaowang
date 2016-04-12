module UsersHelper
  def active_for_login(controller_name)
    controller_name == "sessions" ? "active" : ""
  end

  def active_for_signup(controller_name)
    controller_name == "users" ? "active" : ""
  end
end
