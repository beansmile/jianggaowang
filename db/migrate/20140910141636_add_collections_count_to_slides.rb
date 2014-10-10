class AddCollectionsCountToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :collections_count, :integer, after: :likes_count, default: 0
  end
end
