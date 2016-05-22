class AddCloudStorageFieldsToPreviews < ActiveRecord::Migration
  def change
    add_column :previews, :bucket_domain, :string
    add_column :previews, :bucket, :string
    add_column :previews, :remote_file_path, :string
  end
end
