class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :events, :slides do |t|
      t.index :event_id
      t.index :slide_id
    end
  end
end
