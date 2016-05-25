class AddCloudStorageFieldsToPreviews < ActiveRecord::Migration
  def change
    add_column :previews, :qiniu_file_path, :string
  end
end
