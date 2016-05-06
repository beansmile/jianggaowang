class Event < ActiveRecord::Base
  DEFAULT_SEARCH_SORTS = 'created_at desc'

  # Attr related macros
  mount_uploader :cover, EventUploader
  mount_uploader :editor_choice_image, BaseUploader

  # Associations
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :slides, dependent: :destroy

  # validation macros
  validates :header, :start_at, :end_at, :creator_id, :cover, :venue, presence: true

  # scope
  scope :newest, -> { order(created_at: :desc) }
  scope :pinned, -> { where.not(pinned_at: nil).order(created_at: :desc) }

  # Output format: `%Y-%m-%d %H:%M`, e.g.: "2016-05-05 00:00"
  def start_time
    start_at.strftime("%F %R") if start_at
  end

  # Output format: `%Y-%m-%d %H:%M`, e.g.: "2016-05-05 00:00"
  def end_time
    end_at.strftime("%F %R") if end_at
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
