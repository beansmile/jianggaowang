class Slide < ActiveRecord::Base
  include DeleteRemoteFilesConcern

  validates :title, :description, :user_id, :filename, presence: true

  has_many :previews, dependent: :destroy
  has_many :likes
  has_many :liking_users, through: :likes, source: :user
  has_many :collections
  has_many :collecting_users, through: :collections, source: :user
  belongs_to :category, counter_cache: true
  belongs_to :user

  after_create :auto_generate_previews

  scope :hotest, -> { where('visits_count > 0').order(visits_count: :desc).limit(12) }
  scope :newest, -> { order(created_at: :desc).limit(12) }

  def truncated_title
    if title =~ /\p{Han}+/u   # 包含中文
      title.truncate(14)
    else
      title.truncate(25)
    end
  end

  def retrieve_persistent_state
    return unless persistent_state == 'transforming'

    response = Qiniu::Fop::Persistance.prefop persistent_id
    # The second value returned from api is the target response body,
    # see: https://github.com/qiniu/ruby-sdk/blob/master/lib/qiniu/http.rb#L125
    parse_slide_persistent_results response.second.with_indifferent_access
  end

  def persistent_previews
    total_pages = retrieve_total_pages
    watermark_text = Qiniu::Utils.urlsafe_base64_encode("讲稿网：@#{user.name}")
    bucket = Qiniu::Bucket

    pfops = (1..retrieve_total_pages).map do |page|
      target_key = Digest::MD5.hexdigest(filename) + "-#{page}.jpg"

      "odconv/jpg/page/#{page}/density/150/resize/800|" +
      "watermark/2/text/#{watermark_text}/fontsize/500/dissolve/60|" +
      "saveas/#{Qiniu::Utils.encode_entry_uri(bucket, target_key)}"
    end.join(';')

    notify_url = "#{Qiniu::NotificationHost}/notifications/persistance_finished"
    pfop_policy = Qiniu::Fop::Persistance::PfopPolicy.new(bucket, filename, pfops, notify_url)
    pfop_policy.pipeline = Qiniu::MPSQueue

    # Retry at most 3 times
    3.times do
      response = Qiniu::Fop::Persistance.pfop pfop_policy
      persistent_id = response[1]["persistentId"]

      if persistent_id
        update_attributes persistent_id: persistent_id, persistent_state: "transforming"
        break
      end
    end

    unless persistent_id
      update_attribute :persistent_state, :failed
    end
  end

  def retrieve_total_pages
    uri = URI URI.encode("http://#{Qiniu::Bucket}.qiniudn.com/#{filename}?odconv/jpg/info")
    response = JSON.parse Net::HTTP.get(uri)
    response["page_num"]
  end

  def auto_generate_previews
    delay.persistent_previews
  end

  def increase_visits_counter
    increment! :visits_count
  end

  def parse_slide_persistent_results(params)
    code = params[:code]

    if code.zero? || code == 4 # successful pfop or callback failed
      items = params[:items]
      items.each do |item|
        if item[:code].zero?  # this item is saved
          self.previews.find_or_create_by filename: item[:key]
        end
      end
      update_column :persistent_state, :finished
    else
      update_column :persistent_state, :failed
    end
  end
end
