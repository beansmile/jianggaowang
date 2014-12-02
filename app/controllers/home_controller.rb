class HomeController < ApplicationController
  def index
    @newest_slides = Slide.newest.limit(3)
    @featured_categories = Category.has_slides.order(slides_count: :desc).limit(3)
  end
end
