class HomeController < ApplicationController
  def index
    @featured_categories = Category.has_slides.order(slides_count: :desc).limit(3)
  end
end
