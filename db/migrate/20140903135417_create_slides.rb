class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.string :title
      t.string :description
      t.string :filename
      t.integer :user_id
      t.integer :category_id
      t.boolean :downloadable

      t.timestamps
    end
  end
end
