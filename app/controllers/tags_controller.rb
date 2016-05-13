class TagsController < ApplicationController
  def index
    @tags = Slide.tag_counts_on(:tags).page(params[:page]).per(50)
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find_by! name: params[:name]
    @tagged_slide = Slide.tagged_with(@tag.name).order(created_at: :desc)
                         .page(params[:page])
  end
end
