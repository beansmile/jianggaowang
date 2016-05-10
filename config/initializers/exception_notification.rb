# Only send exception email on Production or Staging server
# type `LOCAL_PRODUCTION=1 rails s -e production` to trigger local production environment
# type `LOCAL_STAGING=1 rails s -e staging` to trigger local staging environment
if (Rails.env.production? || Rails.env.staging?) && !ENV['LOCAL_PRODUCTION'] && !ENV['LOCAL_STAGING']
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => Rails.application.secrets[:exception_email_prefix],
      :sender_address => '"ExceptionNotifier" ' + Rails.application.secrets[:exception_email_sender_address],
      :exception_recipients => Rails.application.secrets[:notification_receivers]
    }
end
