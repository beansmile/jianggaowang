class AddAudioToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :audio, :string
  end
end
