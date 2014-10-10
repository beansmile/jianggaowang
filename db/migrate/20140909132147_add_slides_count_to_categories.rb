class AddSlidesCountToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :slides_count, :integer, after: :name

    Category.reset_column_information
    Category.all.each do |category|
      Category.update_counters category.id, slides_count: category.slides.count
    end
  end

  def down
    remove_column :categories, :slides_count
  end
end
