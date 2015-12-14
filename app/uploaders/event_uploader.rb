class EventUploader < BaseUploader

  version :small do
    process :resize_to_fit => [130, 130]
  end

  version :medium do
    process :resize_to_fit => [340, 340]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
