class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.page(params[:page]).per(50)
  end

  def show
    @category = Category.find(params[:id])
    @slides = @category.slides.page(params[:page]).per(params[:per_page])
  end
end
