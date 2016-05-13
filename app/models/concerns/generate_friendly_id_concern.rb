module GenerateFriendlyIdConcern
  extend ActiveSupport::Concern

  private
  def should_generate_new_friendly_id?
    # friendly_id field
    field = self.class.friendly_id_config.base
    slug.blank? || send("#{field}_changed?")
  end
end
