class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_current_event, only: [:edit, :update, :destroy, :show]

  def index
    @events = current_user.events.order_by_created_at_desc.page(params[:page]).per(params[:per_page])
  end

  def show
    @slides = @event.slides.page(params[:page]).per(10)
  end

  def new
    @event = current_user.events.new
  end

  def create
    @slide = current_user.events.new(event_params)
    if @slide.save
      respond_to do |format|
        format.html { redirect_to events_path }
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

  private

  def event_params
    params.require(:event).permit(:header, :content, :cover, :start_at, :end_at)
  end

  def set_current_event
    @event = current_user.events.find params[:id]
  end
end
