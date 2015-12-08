class AddFileToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :file, :string
  end
end
