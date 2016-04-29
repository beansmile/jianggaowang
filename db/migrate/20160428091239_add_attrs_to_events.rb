class AddAttrsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :pinned_at, :datetime
    add_column :events, :editor_choice_title, :string
    add_column :events, :editor_choice_image, :string
  end
end
