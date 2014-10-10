Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  address:              'smtp.163.com',
  port:                 25,
  user_name:            Rails.application.secrets[:mail]["user_name"],
  password:             Rails.application.secrets[:mail]["password"],
  authentication:       'plain'
}
