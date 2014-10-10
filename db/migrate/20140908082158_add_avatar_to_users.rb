class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string, after: :password_digest
  end
end
