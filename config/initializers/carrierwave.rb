bucket = Rails.application.secrets[:qiniu]['bucket']

::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = Rails.application.secrets[:qiniu]['access_key']
  config.qiniu_secret_key    = Rails.application.secrets[:qiniu]['secret_key']
  config.qiniu_bucket        = bucket
  config.qiniu_bucket_domain = "#{bucket}.qiniudn.com"
  config.qiniu_bucket_private= true #default is false
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = "http"
end
