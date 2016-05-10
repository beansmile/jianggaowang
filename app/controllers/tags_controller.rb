class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.page(params[:page]).per(50)
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find_by! name: params[:name]
    @tagged_slide = Slide.tagged_with(@tag.name).page(params[:page])
  end
end
