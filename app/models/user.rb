class User < ActiveRecord::Base
  has_secure_password
  mount_uploader :avatar, AvatarUploader

  attr_accessor :original_password

  has_many :slides, dependent: :destroy
  has_many :likes
  has_many :liking_slides, through: :likes, source: :slide
  has_many :collections
  has_many :collecting_slides, through: :collections, source: :slide

  validates :name, :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :password, length: { minimum: 8 }, if: -> { changes.include?(:password_digest) }
  validates_uniqueness_of :name, :email, case_sensitive: false

  def friendly_bio
    bio || "这个讲师暂未留下任何自我介绍"
  end

  def liked_slide?(slide)
    liking_slides.include? slide
  end

  def collected_slide?(slide)
    collecting_slides.include? slide
  end

  def generate_reset_password_token
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_token_expires_at = Time.current + 30.minutes
    save
  end

  def clear_reset_password_token
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save
  end
end
