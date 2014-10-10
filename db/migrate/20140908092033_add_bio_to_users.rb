class AddBioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text, after: :name
  end
end
