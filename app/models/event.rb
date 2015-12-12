class Event < ActiveRecord::Base

  # Attr related macros
  mount_uploader :cover, EventUploader

  # Associations
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_and_belongs_to_many :slides
end
