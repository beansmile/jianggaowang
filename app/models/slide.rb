require 'pdf_converter'

class Slide < ActiveRecord::Base
  # constants
  DEFAULT_SEARCH_SORTS = 'created_at desc'

  # concerns
  include DisqusConcern
  extend FriendlyId

  # attr related macros
  mount_uploader :file, PDFUploader
  friendly_id :title, use: :slugged
  # first set friendly_id, then define should_generate_new_friendly_id?
  include GenerateFriendlyIdConcern

  acts_as_taggable

  enum status: { transforming: 1, done: 2, failed: 3 }

  # association
  has_many :previews, -> { order(id: :asc) }, dependent: :destroy
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
  has_many :collections
  has_many :collecting_users, through: :collections, source: :user
  belongs_to :user
  belongs_to :event

  # validation macros
  validates :title, :description, :user_id, :file, :author, :event_id, presence: true

  # callbacks
  after_save :add_tags_to_event, if: :tag_list_changed?
  after_commit :convert_file, on: :create
  after_commit :update_file, on: :update

  # scopes
  scope :hottest, -> { done.where('visits_count > 0').order(visits_count: :desc) }
  scope :newest, -> { done.order(created_at: :desc) }

  def convert
    return if previews.any? || !File.exist?(self.file.path)
    temp_directory = Rails.root.join("tmp/slides/#{id}")

    previews_count = PDFConverter.convert(file.path, temp_directory)
    0.upto(previews_count - 1).each do |page_count|
      preview_path = if previews_count == 1
                       "#{temp_directory}/preview.jpg"
                     else
                       "#{temp_directory}/preview-#{page_count}.jpg"
                     end
      if File.exist? preview_path
        self.previews.create(file: File.open(preview_path))
      end
    end

    if previews_count >= 1 && self.previews.count == previews_count
      self.done!
      true
    else
      self.failed!
      false
    end
  ensure
    FileUtils.rm_rf(temp_directory) # clear existed files
  end

  def convert!
    previews.destroy_all # clear existed previews
    convert
  end

  def increase_visits_counter
    increment! :visits_count
  end

  def related_recommendations
    Slide.tagged_with(tag_list, any: true).where.not(id: id).hottest
  end

  # use id-slug
  def normalize_friendly_id(string)
    [id, PinYin.permlink(title).downcase].join('-')
  end

  def audio
    value = read_attribute(:audio) || ''
    OpenStruct.new(
      value: value,
      file_name: value.split('/').last,
      url: URI.encode("http://#{Qiniu::Config.settings[:bucket_domain]}/#{value}")
    )
  end

  private

  def convert_file
    SlideConvertJob.perform_later(id)
    # use update_columns to skip callback
    # due to: https://github.com/rails/rails/issues/14493
    update_columns status: Slide.statuses['transforming']
  end

  def update_file
    if previous_changes.key? 'file'
      # use update_columns to skip callback
      # due to: https://github.com/rails/rails/issues/14493
      update_columns status: Slide.statuses['transforming']
      SlideConvertJob.perform_later(id)
    end
  end

  def add_tags_to_event
    event.tag_list.add tag_list
    event.save
  end
end
