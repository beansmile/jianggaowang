class Event < ActiveRecord::Base

  # Attr related macros
  mount_uploader :cover, EventUploader

  # Associations
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :slides, dependent: :destroy

  # scope
  scope :newest, -> { order(created_at: :desc) }

  def start_time
    start_at.strftime("%Y-%m-%d") if start_at
  end

  def end_time
    end_at.strftime("%Y-%m-%d") if end_at
  end
end
