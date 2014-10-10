class Preview < ActiveRecord::Base
  include DeleteRemoteFilesConcern

  belongs_to :slide
end
