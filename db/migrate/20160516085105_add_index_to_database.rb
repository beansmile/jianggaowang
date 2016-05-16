class AddIndexToDatabase < ActiveRecord::Migration
  def change
    add_index :events, :creator_id
    add_index :previews, :slide_id
    add_index :likes, [:slide_id, :user_id]
    add_index :slides, [:user_id, :event_id]
    add_index :collections, [:user_id, :slide_id]
  end
end
