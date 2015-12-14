class Event < ActiveRecord::Base

  # Attr related macros
  mount_uploader :cover, EventUploader

  # Associations
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :slides

  def start_time
    start_at.strftime("%m/%d/%Y") if start_at
  end

  def end_time
    end_at.strftime("%m/%d/%Y") if end_at
  end
end
