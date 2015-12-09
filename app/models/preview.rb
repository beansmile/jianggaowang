class Preview < ActiveRecord::Base
  mount_uploader :file, PreviewUploader

  belongs_to :slide
end
