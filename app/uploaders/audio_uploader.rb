# encoding: utf-8

class AudioUploader < BaseUploader
  def extension_white_list
    %w(mp3 wav ogg)
  end
end
