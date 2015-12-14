# encoding: utf-8

class PreviewUploader < BaseUploader
  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [200, 200]
  end
end
