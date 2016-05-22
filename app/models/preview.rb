class Preview < ActiveRecord::Base
  mount_uploader :file, PreviewUploader
  after_destroy :delete_remote_file

  belongs_to :slide

  def delete_remote_file
    if bucket? && remote_file_path?
      RemoteFileDeleteJob.perform_later(qiniu_bucket, qiniu_file_path)
    end
  end
end
