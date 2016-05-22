class PreviewsUploadJob < ActiveJob::Base
  queue_as :uploads

  def perform(slide_id)
    slide = Slide.find slide_id
    if slide.status == "done" && (previews = slide.previews).any?
      previews.each do |preview|
        remote_file_path = Pathname.new(preview.file.path).relative_path_from(Rails.root)

        code, result, _ = Qiniu::Storage.upload_with_token_2(
          upload_token,
          preview.file.path,
          remote_file_path
        )

        if code.to_s == "200"
          preview.update(
            bucket_domain: Qiniu::Config.settings[:bucket_domain],
            bucket: Qiniu::Config.settings[:bucket],
            remote_file_path: result["key"]
          )
        else
          raise "Upload Failed"
        end
      end
    end
  end

  def upload_token
    return @upload_token if @upload_token

    put_policy = Qiniu::Auth::PutPolicy.new(Qiniu::Config.settings[:bucket], nil, 3600)
    @upload_token = Qiniu::Auth.generate_uptoken(put_policy)
  end
end
