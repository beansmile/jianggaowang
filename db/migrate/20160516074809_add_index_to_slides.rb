class AddIndexToSlides < ActiveRecord::Migration
  def change
    add_index :slides, [:user_id, :event_id]
  end
end
