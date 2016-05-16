module GenerateFriendlyIdConcern
  extend ActiveSupport::Concern
  included do
    # fix no id before commit
    after_commit :update_slug, on: :create
  end


  private

  def update_slug
    update_column(:slug, normalize_friendly_id(nil))
  end

  def should_generate_new_friendly_id?
    # friendly_id field
    field = self.class.friendly_id_config.base
    slug.blank? || send("#{field}_changed?")
  end
end
