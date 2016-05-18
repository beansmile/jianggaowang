class SlidesController < ApplicationController
  include FriendlyIdConcern
  RECOMMENDED_SLIDES_COUNT = 2

  before_action :authenticate_user!, only: [:new, :create, :like, :collect]
  before_action :find_slide, only: [:edit, :update, :destroy, :download]
  after_action :increase_slide_visits_count, only: [:show]

  def index
    @slides = Slide.newest.page(params[:page])
  end

  def show
    @slide = Slide.includes(:previews, :tags).friendly.find(params[:id])
    # redirect to correct path if request.path is not correct
    if request.path != slide_path(@slide)
      return redirect_to @slide
    end
    @recommended_slides = @slide.related_recommendations
                                .limit(RECOMMENDED_SLIDES_COUNT)
  end

  def new
    @slide = Slide.new(event: current_user.events.friendly.find(params[:id]))
  end

  def create
    @slide = current_user.new_slide_under_event(slide_params, params[:event_id])

    if @slide.save
      redirect_to slide_path(@slide)
    else
      flash.now[:error] = @slide.errors.full_messages.join(';')
      render :new
    end
  end

  def destroy
    if @slide.destroy
      flash[:info] = "讲稿《#{@slide.title}》删除成功！"
    else
      flash[:warning] = "讲稿无法删除，请稍后重试"
    end

    if params[:from] == 'show'
      redirect_to event_path(@slide.event)
    else
      redirect_to :back
    end
  end

  def edit
  end

  def update
    if @slide.update_attributes(slide_params)
      flash[:success] = "讲稿《#{@slide.title}》编辑成功"
      redirect_to @slide
    else
      flash.now[:error] = @slide.errors.full_messages.join('，')
      render :edit
    end
  end

  def like
    slide = Slide.friendly.find params[:id]
    slide.likes.build user: current_user
    if slide.save
      render json: { likes_count: slide.reload.likes_count }
    else
      render json: { message: "您已经为讲稿“#{slide.title}”点过赞，请不要重复操作" }, status: 406
    end
  end

  def collect
    slide = Slide.friendly.find params[:id]
    slide.collections.build user: current_user
    if slide.save
      render json: { collections_count: slide.reload.collections_count }
    else
      render json: { message: "您已经收藏讲稿“#{slide.title}”，请不要重复操作" }, status: 406
    end
  end

  def manual_process
    @slide = current_user.slides.friendly.find_by id: params[:id]
    if @slide
      flash[:warning] = "您的讲稿已经重新提交处理，稍后进入处理状态，请勿重复提交处理"
      SlideConvertJob.perform_later(@slide.id)
    end

    redirect_to :back
  end

  def search
    @keyword = params[:keyword]

    slides_query = Slide.ransack(title_cont: @keyword)
    slides_query.sorts = Slide::DEFAULT_SEARCH_SORTS
    @slides = slides_query.result.page(params[:page])
  end

  def hottest
    @slides = Slide.hottest.page(params[:page])
  end

  def download
    filename = "#{@slide.title}.pdf"

    send_file @slide.file.path, filename: filename
  end

  private
  def increase_slide_visits_count
    user_agent = request.env['HTTP_USER_AGENT']
    if user_agent && !user_agent.match(/\(.*https?:\/\/.*\)/)
      @slide.increase_visits_counter
    end
  end

  def slide_params
    params.require(:slide).permit(
      :title, :description, :file, :downloadable, :author, :tag_list,
      :audio, :file_cache
    )
  end

  def find_slide
    @slide = Slide.friendly.find params[:id]
  end
end
