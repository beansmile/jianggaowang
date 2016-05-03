class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_current_event, only: [:edit, :update, :destroy]

  def index
    @events = Event.newest.page(params[:page])
  end

  # show action is open to guest so that they see the events and the slides.
  def show
    @event = Event.find params[:id]
    @slides = @event.slides
  end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      respond_to do |format|
        format.html { redirect_to @event }
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(event_params)
      flash[:success] = "活动更新成功"
      redirect_to event_path(@event)
    else
      flash[:danger] = "活动更新失败,原因:#{@event.errors.full_messages.join('，')}"
      render 'edit'
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  def choose
    @events = current_user.events.newest.page(params[:page])
  end

  def search
    @keyword = params[:keyword]

    events_query = Event.ransack(header_cont: @keyword)
    events_query.sorts = Event::DEFAULT_SEARCH_SORTS
    @events = events_query.result.page(params[:page])
  end

  private

  def event_params
    params.require(:event).permit(:header, :content, :cover, :start_at, :end_at)
  end

  def set_current_event
    @event = current_user.events.find params[:id]
  end
end
