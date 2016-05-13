module FriendlyIdConcern
  extend ActiveSupport::Concern
  included do
    before_action :split_id_from_slug, only: :show
  end

  private
  # split record id from slug
  def split_id_from_slug
    params[:id] = params[:id].split('-').first.to_i
  end
end
