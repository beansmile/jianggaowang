class ContentScrubber < Rails::Html::PermitScrubber
  def allowed_node?(node)
    %w(p b u strike blockquote span ul ol li br a).include?(node.name)
  end

  def skip_node?(node)
    node.text?
  end

  def scrub_attribute?(name)
    !%(style href target).include?(name)
  end
end
