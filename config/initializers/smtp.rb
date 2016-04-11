Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  address:              'smtp.exmail.qq.com',
  port:                 465,
  user_name:            Rails.application.secrets.mail['user_name'],
  password:             Rails.application.secrets.mail['password'],
  authentication:       'plain',
  enable_starttls_auto: true,
  tls: true
}
