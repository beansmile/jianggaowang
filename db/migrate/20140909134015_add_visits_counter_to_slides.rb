class AddVisitsCounterToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :visits_count, :integer, default: 0, after: :persistent_state
  end
end
