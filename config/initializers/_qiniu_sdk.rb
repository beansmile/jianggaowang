access_key = Rails.application.secrets[:qiniu]['access_key']
secret_key = Rails.application.secrets[:qiniu]['secret_key']
Qiniu.establish_connection! :access_key => access_key,
                            :secret_key => secret_key
Qiniu::Bucket = Rails.application.secrets[:qiniu]['bucket']
