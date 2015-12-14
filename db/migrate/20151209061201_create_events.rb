class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :header
      t.text :content
      t.datetime :start_at
      t.datetime :end_at
      t.integer :creator_id
      t.string :cover

      t.timestamps null: false
    end
  end
end
