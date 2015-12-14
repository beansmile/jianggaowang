class HomeController < ApplicationController
  def index
    @events = Event.order_by_created_at_desc.page(params[:page]).per(params[:per_page] || 10)
  end
end
