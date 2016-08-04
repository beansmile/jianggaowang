class Preview < ActiveRecord::Base
  mount_uploader :file, PreviewUploader
  after_destroy :delete_remote_file

  belongs_to :slide

  THUMBNAILS = {
    thumb: "400x400",
    middle: "800x800",
    large: "1024x1024"
  }

  def delete_remote_file
    if qiniu_file_path?
      bucket = Qiniu::Config.settings[:bucket]
      RemoteFileDeleteJob.perform_later(bucket, qiniu_file_path)
    end
  end

  # 返回预览图的链接，云存储的文件支持多尺寸
  #
  # @param version [Symbol] 指定云存储文件的图片尺寸，对应支持：
  #   thumb: 宽高最大矩形为 400x400
  #   middle: 宽高最大矩形为 800x800
  #   large: 宽高最大矩形为 1024x1024
  #   original: 原图
  # @return [String] 图片的链接，e.g.:
  #   1) http://jianggao-development.qiniudn.com/public/uploads/preview/file/133/preview-28.jpg?imageView2/2/w/800/h/800/q/100/
  #   2) http://localhost:3000/uploads/preview/file/56/preview-0.jpg
  # @note 当预览图未上传到云存储时，默认使用文件系统链接，此时 `version` 参数只支持 :thumb
  #
  def url(version = :thumb)
    uploaded_to_cloud? ? url_from_cloud(version) : url_from_file_system(version)
  end

  private
  def available_versions
    THUMBNAILS.keys + [:original]
  end

  def valid_version?(version)
    available_versions.include?(version.to_s.to_sym)
  end

  def uploaded_to_cloud?
    qiniu_file_path?
  end

  def url_from_cloud(version)
    bucket_domain = Qiniu::Config.settings[:bucket_domain]

    version = valid_version?(version) ? version.to_sym : :thumb
    original_file_path = "http://#{bucket_domain}/#{qiniu_file_path}"
    return original_file_path if version == :original

    max_width, max_height = THUMBNAILS[version].split("x")
    # http://developer.qiniu.com/code/v6/api/kodo-api/image/imageview2.html
    "#{original_file_path}?imageView2/2/w/#{max_width}/h/#{max_height}/q/100"
  end

  def url_from_file_system(version)
    file.url(version.to_s == "thumb" ? :thumb : nil) if file
  end
end
