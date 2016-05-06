# rescue is used to compatiable with coding.net
access_key = Rails.application.secrets[:qiniu]['access_key']
secret_key = Rails.application.secrets[:qiniu]['secret_key']
Qiniu.establish_connection! :access_key => access_key,
                            :secret_key => secret_key
Qiniu::Bucket = Rails.application.secrets[:qiniu]['bucket']
Qiniu::MPSQueue = Rails.application.secrets[:qiniu]['mps_queue']
Qiniu::NotificationHost = Rails.application.secrets[:host]
