class HomeController < ApplicationController
  HOMEPAGE_DEMO_COUNT = 4

  def index
    @events = Event.order_by_created_at_desc.limit(HOMEPAGE_DEMO_COUNT)
    @hotest_slides = Slide.hotest.limit(HOMEPAGE_DEMO_COUNT)
    @newest_slides = Slide.newest.limit(HOMEPAGE_DEMO_COUNT)
  end

  def static_page
  end
end
