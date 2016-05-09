class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.page(params[:page]).per(50)
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find params[:id]
    @tagged_slide = Slide.tagged_with(@tag.name).page(params[:page])
  end
end
