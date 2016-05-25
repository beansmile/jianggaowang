class SlideConvertJob < ActiveJob::Base
  queue_as :jianggaowang

  def perform(slide_id)
    slide = Slide.find slide_id
    if slide.convert!
      PreviewsUploadJob.perform_later(slide_id)
    end
  end
end
