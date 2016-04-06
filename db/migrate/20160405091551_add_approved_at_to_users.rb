class AddApprovedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approved_at, :datetime
  end
end
