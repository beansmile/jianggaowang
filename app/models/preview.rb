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
    if bucket? && remote_file_path?
      RemoteFileDeleteJob.perform_later(qiniu_bucket, qiniu_file_path)
    end
  end

  def url(version = :thumb)
    uploaded_to_cloud? ? url_from_cloud(version) : url_from_file_system
  end

  private
  def available_versions
    THUMBNAILS.keys + [:original]
  end

  def valid_version?(version)
    available_versions.include?(version.to_s.to_sym)
  end

  def uploaded_to_cloud?
    qiniu_bucket? && qiniu_file_path
  end

  def url_from_cloud(version)
    version = valid_version?(version) ? version.to_sym : :thumb
    original_file_path = "http://#{qiniu_bucket_domain}/#{qiniu_file_path}"
    return original_file_path if version == :original

    max_width, max_height = THUMBNAILS[version].split("x")
    # http://developer.qiniu.com/code/v6/api/kodo-api/image/imageview2.html
    "#{original_file_path}?imageView2/2/w/#{max_width}/h/#{max_height}/q/100"
  end

  def url_from_file_system
    file.try(:url)
  end
end
