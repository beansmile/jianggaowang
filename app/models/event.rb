class Event < ActiveRecord::Base

  # Attr related macros
  mount_uploader :cover, EventUploader
  mount_uploader :editor_choice_image, BaseUploader

  # Associations
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :slides, dependent: :destroy

  # scope
  scope :newest, -> { order(created_at: :desc) }
  scope :pinned, -> { where.not(pinned_at: nil).order(created_at: :desc) }

  def start_time
    start_at.strftime("%Y-%m-%d") if start_at
  end

  def end_time
    end_at.strftime("%Y-%m-%d") if end_at
  end

  def pinned
    !!pinned_at
  end

  def pinned=(val)
    # ActiveAdmin use "1" to denote true
    if val == "1"
      self.pinned_at = Time.current
    else
      self.pinned_at = nil
    end
  end

end
