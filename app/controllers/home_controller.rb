class HomeController < ApplicationController
  HOMEPAGE_DEMO_COUNT = 4

  def index
    @events = Event.newest.limit(HOMEPAGE_DEMO_COUNT)
    @pinned_events = Event.pinned
    @hottest_slides = Slide.hottest.limit(HOMEPAGE_DEMO_COUNT)
    @newest_slides = Slide.newest.limit(HOMEPAGE_DEMO_COUNT)
  end
end
