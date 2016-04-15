module ApplicationHelper
  def resource_url(filename)
    "http://#{Qiniu::Bucket}.qiniudn.com/#{filename}"
  end

  def slide_first_or_default_preview_url(slide)
    if slide.previews.any?
      image_url(slide.previews.first.file.url(:thumb))
    else
      'default_preview.gif'
    end
  end

  def active_link(page, controller_name)
    page == controller_name ? "active" : nil
  end
end
