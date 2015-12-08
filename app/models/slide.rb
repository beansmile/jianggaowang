require 'pdf_converter'

class Slide < ActiveRecord::Base
  include DeleteRemoteFilesConcern

  mount_uploader :file, AttachmentUploader

  validates :title, :description, :user_id, :file, presence: true

  has_many :previews, dependent: :destroy
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
  has_many :collections
  has_many :collecting_users, through: :collections, source: :user
  belongs_to :category, counter_cache: true
  belongs_to :user

  scope :hotest, -> { where('visits_count > 0').order(visits_count: :desc).limit(12) }
  scope :newest, -> { order(created_at: :desc).limit(12) }

  def truncated_title
    if title =~ /\p{Han}+/u   # 包含中文
      title.truncate(14)
    else
      title.truncate(25)
    end
  end

  def convert
    return if previews.any?

    previews_count = PDFConverter.convert(file.path, "public/slides/#{id}/", "preview")
    0.upto(previews_count - 1).each do |page|
      self.previews.create(filename: "/slides/#{id}/preview-#{page}.jpg")
    end
  end

  def convert!
    previews.destroy_all                    # clear existed previews
    FileUtils.rm_rf("public/slides/#{id}/") # clear existed files

    convert
  end

  def increase_visits_counter
    increment! :visits_count
  end
end
