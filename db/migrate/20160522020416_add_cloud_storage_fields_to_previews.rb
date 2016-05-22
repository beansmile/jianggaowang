class AddCloudStorageFieldsToPreviews < ActiveRecord::Migration
  def change
    add_column :previews, :qiniu_bucket_domain, :string
    add_column :previews, :qiniu_bucket, :string
    add_column :previews, :qiniu_file_path, :string
  end
end
