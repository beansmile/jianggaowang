class AddLikesCountToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :likes_count, :integer, after: :visits_count, default: 0
  end
end
