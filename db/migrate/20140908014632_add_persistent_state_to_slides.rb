class AddPersistentStateToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :persistent_state, :string, after: :persistent_id
  end
end
