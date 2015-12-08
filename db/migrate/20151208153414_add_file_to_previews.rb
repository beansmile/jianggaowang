class AddFileToPreviews < ActiveRecord::Migration
  def change
    add_column :previews, :file, :string
  end
end
