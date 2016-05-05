class RemoveCategoryIdFromSlides < ActiveRecord::Migration
  def change
    remove_column :slides, :category_id
  end
end
