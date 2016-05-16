class AddIndexToLikes < ActiveRecord::Migration
  def change
    add_index :likes, [:slide_id, :user_id]
  end
end
