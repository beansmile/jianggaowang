require 'pdf_converter'

class Slide < ActiveRecord::Base
  # attr related macros
  mount_uploader :file, PDFUploader
  enum status: { transforming: 1, done: 2, failed: 3 }

  # association
  has_many :previews, dependent: :destroy
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
  has_many :collections
  has_many :collecting_users, through: :collections, source: :user
  belongs_to :category, counter_cache: true
  belongs_to :user
  belongs_to :event

  # validation macros
  validates :title, :description, :user_id, :file, presence: true

  # callbacks
  after_create :convert_file

  # scopes
  scope :hotest, -> { where('visits_count > 0').order(visits_count: :desc).limit(12) }
  scope :newest, -> { order(created_at: :desc).limit(12) }

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

    if self.previews.count == previews_count
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

  private
  def convert_file
    SlideConvertJob.perform_later(id)
    self.transforming!
  end
end
