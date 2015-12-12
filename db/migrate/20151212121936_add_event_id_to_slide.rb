class AddEventIdToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :event_id, :integer
  end
end
