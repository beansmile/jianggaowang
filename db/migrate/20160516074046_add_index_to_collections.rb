class AddIndexToCollections < ActiveRecord::Migration
  def change
    add_index :collections, [:user_id, :slide_id]
  end
end
