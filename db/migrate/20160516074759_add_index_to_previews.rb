class AddIndexToPreviews < ActiveRecord::Migration
  def change
    add_index :previews, :slide_id
  end
end
