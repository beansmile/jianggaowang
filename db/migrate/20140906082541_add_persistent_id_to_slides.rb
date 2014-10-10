class AddPersistentIdToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :persistent_id, :string, after: :downloadable
  end
end
