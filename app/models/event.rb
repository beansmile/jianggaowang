class Event < ActiveRecord::Base
  # constants
  DEFAULT_SEARCH_SORTS = 'created_at desc'

  # concerns
  include DisqusConcern
  extend FriendlyId

  # Attr related macros
  mount_uploader :cover, EventUploader
  mount_uploader :editor_choice_image, BaseUploader
  friendly_id :header, use: :slugged
  # first set friendly_id, then define should_generate_new_friendly_id?
  include GenerateFriendlyIdConcern

  acts_as_taggable

  # Associations
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :slides, dependent: :destroy

  # validation macros
  validates :header, :start_at, :end_at, :creator_id, :cover, :venue, presence: true
  validate :end_time_cannot_before_start_time

  # scope
  scope :newest, -> { order(created_at: :desc) }
  scope :pinned, -> { where.not(pinned_at: nil).order(created_at: :desc) }

  # Output format: `%Y-%m-%d`, e.g.: "2016-05-05"
  def start_time
    start_at.strftime("%F") if start_at
  end

  # Output format: `%Y-%m-%d`, e.g.: "2016-05-05"
  def end_time
    end_at.strftime("%F") if end_at
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

  # use id-slug
  def normalize_friendly_id(string)
    [id, PinYin.permlink(header).downcase].join('-')
  end

  def related_recommendations
    Event.tagged_with(tag_list, any: true).where.not(id: id)
  end

  private

  def end_time_cannot_before_start_time
    return if end_at.blank? || start_at.blank?

    errors.add(:end_at, "不能早于开始时间") if end_at < start_at
  end
end
