# coding: utf-8
module DisqusConcern
  extend ActiveSupport::Concern

  def disqus_identifier
    [self.class.name, id].join('-')
  end
end
