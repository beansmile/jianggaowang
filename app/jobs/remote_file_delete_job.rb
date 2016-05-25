# delete file which has been uploaded to the cloud storage but now is to be
# deleted locally, we use this job to replay a delete operation in the cloud
#
class RemoteFileDeleteJob < ActiveJob::Base
  queue_as :remote_file_delete

  def perform(bucket, remote_file_path)
    Qiniu::Storage.delete(bucket, remote_file_path)
  end
end
