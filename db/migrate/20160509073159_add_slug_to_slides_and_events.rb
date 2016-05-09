class AddSlugToSlidesAndEvents < ActiveRecord::Migration
  def change
    add_column :slides, :slug, :string
    add_index :slides, :slug, unique: true
    add_column :events, :slug, :string
    add_index :events, :slug, unique: true
  end
end
