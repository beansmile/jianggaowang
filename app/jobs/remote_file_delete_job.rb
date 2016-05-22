class RemoteFileDeleteJob < ActiveJob::Base
  queue_as :remote_files_management

  def perform(bucket, remote_file_path)
    Qiniu::Storage.delete(bucket, remote_file_path)
  end
end
