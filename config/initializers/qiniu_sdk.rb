# use a hash from secrets.yml makes use of Qiniu::Config.settings
# that is, `Qiniu::Config.settings` will merge all options from here,
# then you can conviniently use something like:
#   `Qiniu::Config.settings[:bucket]` => "your_configured_bucket"
#
Qiniu.establish_connection! Rails.application.secrets[:qiniu].symbolize_keys
