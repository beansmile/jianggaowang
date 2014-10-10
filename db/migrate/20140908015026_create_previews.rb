class CreatePreviews < ActiveRecord::Migration
  def change
    create_table :previews do |t|
      t.integer :slide_id
      t.string :filename

      t.timestamps
    end
  end
end
