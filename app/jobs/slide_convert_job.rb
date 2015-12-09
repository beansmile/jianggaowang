class SlideConvertJob < ActiveJob::Base
  queue_as :default

  def perform(slide_id)
    slide = Slide.find_by id: slide_id
    return unless slide.present?

    puts "Converting slide with id=#{slide_id}"
    slide.convert!
  end
end
