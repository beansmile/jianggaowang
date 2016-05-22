class QiniuController < ApplicationController
  before_action :authenticate_user!

  def uploader_config
    put_policy = Qiniu::Auth::PutPolicy.new(
      Qiniu::Config.settings[:bucket],
      nil,
      3600
    )
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
    render json: {
      uptoken: uptoken,
      domain: Qiniu::Config.settings[:bucket_domain]
    }
  end
end
