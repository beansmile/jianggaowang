class SlideConvertJob < ActiveJob::Base
  queue_as :jianggaowang

  def perform(slide_id)
    slide = Slide.find slide_id
    puts "start to convert slide #{slide.id}"
    slide.convert!
  end
end
