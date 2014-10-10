module DeleteRemoteFilesConcern
  extend ActiveSupport::Concern

  included do
    around_destroy :delete_remote_file
  end

  # instance methods
  def delete_remote_file
    key = filename
    yield

    Qiniu.delay.delete(Qiniu::Bucket, key)
  end
end
