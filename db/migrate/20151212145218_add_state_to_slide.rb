class AddStateToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :status, :integer, default: 0
  end
end
