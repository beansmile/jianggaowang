class RemovePersistentIdAndPersistentStateFromSlide < ActiveRecord::Migration
  def change
    remove_column :slides, :persistent_state
    remove_column :slides, :persistent_id
  end
end
