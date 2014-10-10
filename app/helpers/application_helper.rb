module ApplicationHelper
  def resource_url(filename)
    "http://#{Qiniu::Bucket}.qiniudn.com/#{filename}"
  end

  def slide_first_or_default_preview_url(slide)
    if slide.previews.any?
      slide_preview_url slide.previews.first.filename
    else
      image_path 'default_preview.gif'
    end
  end

  def slide_preview_url(filename)
    # this requires we have set style on qiniu's dashboard
    # https://portal.qiniu.com/bucket/data-process/image?bucket=xxx
    # will be something like:
    # =>  http://jianggao-development.qiniudn.com/10f65c99ba398588d0320e23f5640d72-1.jpg-preview
    "#{resource_url(filename)}-preview"
  end
end
