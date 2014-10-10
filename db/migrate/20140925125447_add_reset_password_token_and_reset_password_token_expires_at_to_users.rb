class AddResetPasswordTokenAndResetPasswordTokenExpiresAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_token, :string, after: :avatar
    add_column :users, :reset_password_token_expires_at, :datetime, after: :reset_password_token
  end
end
