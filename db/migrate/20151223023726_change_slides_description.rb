class ChangeSlidesDescription < ActiveRecord::Migration
  def self.up
    change_column :slides, :description, :text
  end

  def self.down
    change_column :slides, :description, :string
  end
end
