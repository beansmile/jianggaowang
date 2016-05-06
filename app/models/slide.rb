require 'pdf_converter'

class Slide < ActiveRecord::Base
  DEFAULT_SEARCH_SORTS = 'created_at desc'

  # attr related macros
  mount_uploader :file, PDFUploader
  mount_uploader :audio, AudioUploader

  acts_as_taggable

  enum status: { transforming: 1, done: 2, failed: 3 }

  # association
  has_many :previews, dependent: :destroy
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
  has_many :collections
  has_many :collecting_users, through: :collections, source: :user
  belongs_to :user
  belongs_to :event

  # validation macros
  validates :title, :description, :user_id, :file, :author, presence: true

  # callbacks
  after_create :convert_file
  after_update :update_file

  # scopes
  scope :hottest, -> { where('visits_count > 0').order(visits_count: :desc) }
  scope :newest, -> { order(created_at: :desc) }

  # instance method
  def truncated_title
    if title =~ /\p{Han}+/u   # 包含中文
      title.truncate(14)
    else
      title.truncate(25)
    end
  end

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
    else
      self.failed!
    end

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

  private
  def convert_file
    SlideConvertJob.perform_later(id)
    self.transforming!
  end

  def update_file
    # self.transforming! will case the callback again
    if self.file_changed? && !self.status_changed?
      self.transforming!
      SlideConvertJob.perform_later(id)
    end
  end
end
