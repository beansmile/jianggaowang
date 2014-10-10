class Category < ActiveRecord::Base
  validates :name, presence: true
  has_many :slides

  scope :has_slides, -> { where.not(slides_count: nil) }
end
