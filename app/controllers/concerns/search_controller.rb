class SearchController < ApplicationController
  DEFAULT_ITEM_COUNT = 8

  def index
    @keyword = params[:keyword]

    events_query = Event.ransack(header_cont: @keyword)
    events_query.sorts = Event::DEFAULT_SEARCH_SORTS
    @events = events_query.result.page(1).per(DEFAULT_ITEM_COUNT)

    slides_query = Slide.ransack(title_cont: @keyword)
    slides_query.sorts = Slide::DEFAULT_SEARCH_SORTS
    @slides = slides_query.result.page(1).per(DEFAULT_ITEM_COUNT)
  end
end
