class Collection < ActiveRecord::Base
  belongs_to :slide, counter_cache: true
  belongs_to :user

  validates_uniqueness_of :slide_id, scope: :user_id
end
