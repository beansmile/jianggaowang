class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_qiniu_request, only: [:slide_uploaded]

  def slide_uploaded
    unless params[:mime_type] == 'application/pdf'
      return render json: {status: 'failed', errors: '不支持的文件格式'}
    end

    slide = Slide.new params[:slide].permit!
    if slide.save
      render json: {status: 'success', slide: slide}
    else
      render json: {status: 'failed', errors: slide.errors.full_messages.join(',')}
    end
  end

  # TODO:
  #   1. use :id in request to mark slide persistent state
  #   2. use a sercet token to verify valid requests, for example:
  #     "#{Qiniu::NotificationHost}/notifications/persistance_finished/:secret_token"
  def persistance_finished
    slide = Slide.find_by persistent_id: params[:id]
    slide.parse_slide_persistent_results(params) if slide

    render json: {status: 'confirmed'}
  end

  private
  def verify_qiniu_request
    render nothing: true, status: 403 and return false unless is_qiniu_callback
  end

  def is_qiniu_callback
    authorization_header = request.headers['Authorization']

    return false unless authorization_header && authorization_header.index("QBox").zero?

    remote_token = authorization_header[5..-1]
    access_token = Qiniu::Auth.generate_acctoken request.url, request.body.read
    return false unless remote_token == access_token

    true
  end
end
