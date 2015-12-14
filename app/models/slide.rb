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
  # https://github.com/mperham/sidekiq/wiki/Problems-and-Troubleshooting#cannot-find-modelname-with-id12345
  # after_commit :convert_file, :on => :create
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

    PDFConverter.convert(file.path, temp_directory)
    Dir.glob("#{temp_directory}/preview-*.jpg").each do |preview|
      self.previews.create(file: File.open(preview))
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
