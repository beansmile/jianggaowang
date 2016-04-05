class AddAuthorToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :author, :string
  end
end
