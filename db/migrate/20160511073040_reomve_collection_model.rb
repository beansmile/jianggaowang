class ReomveCollectionModel < ActiveRecord::Migration
  def change
    remove_column :slides, :collections_count
    drop_table :collections
  end
end
