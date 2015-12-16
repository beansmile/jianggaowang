class SlidesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :like, :collect]
  after_action :increase_slide_visits_count, only: [:show]

  def show
    @slide = Slide.includes(:previews).find(params[:id])
    @category = @slide.category
    respond_to do |format|
      format.html
      format.html.phone {render :layout => 'mobile'}
    end
  end

  def new
    @slide = Slide.new
  end

  def create
    @slide = current_user.slides.new(slide_params)
    @slide.event = Event.find(params[:event_id]) if params[:event_id].present? && Event.exists?(params[:event_id])
    if @slide.save
      render json: {status: "success", slide: {id: @slide.id, event_id: @slide.event_id}}
    else
      render json: {errors: @slide.errors.full_messages.join(";")}
    end
  end

  def destroy
    @slide = Slide.find params[:id]
    if @slide.destroy
      flash[:info] = "讲稿《#{@slide.title}》删除成功！"
    else
      flash[:warning] = "讲稿无法删除，请稍后重试"
    end

    redirect_to :back
  end

  def like
    slide = Slide.find params[:id]
    slide.likes.build user: current_user
    if slide.save
      render json: { likes_count: slide.reload.likes_count }
    else
      render json: { message: "您已经为讲稿“#{slide.title}”点过赞，请不要重复操作" }, status: 406
    end
  end

  def collect
    slide = Slide.find params[:id]
    slide.collections.build user: current_user
    if slide.save
      render json: { collections_count: slide.reload.collections_count }
    else
      render json: { message: "您已经收藏讲稿“#{slide.title}”，请不要重复操作" }, status: 406
    end
  end

  def process_retrieve
    @slide = current_user.slides.find_by id: params[:id]
    if @slide
      @slide.retrieve_persistent_state
    end

    redirect_to :back
  end

  def manual_process
    @slide = current_user.slides.find_by id: params[:id]
    if @slide
      flash[:warning] = "您的讲稿已经重新提交处理，稍后进入处理状态，请勿重复提交处理"
      @slide.delay.persistent_previews
    end

    redirect_to :back
  end

  def upload_result
    if (slide = Slide.find_by filename: params[:resource_key])
      flash[:success] = "讲稿《#{slide.title}》上传成功"
      redirect_to slide
    else
      flash[:danger] = "讲稿上传失败，请尝试重新上传！如有需要，请与管理员hongzeqin@gmail.com联系"
      redirect_to new_slide_path
    end
  end

  def search
    @keyword = params[:keyword]

    if @keyword
      @slides = Slide.where("title like '%#{@keyword}%'").page(params[:page])
    else
      @slides = Slide.page(params[:page])
    end
  end

  private
  def increase_slide_visits_count
    unless request.env["HTTP_USER_AGENT"].match(/\(.*https?:\/\/.*\)/)
      @slide.increase_visits_counter
    end
  end

  def slide_params
    params.require(:slide).permit(:title, :description, :file, :category_id, :downloadable)
  end
end
