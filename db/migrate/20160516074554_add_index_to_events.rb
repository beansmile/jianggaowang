class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, :creator_id
  end
end
