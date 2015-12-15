# https://gist.github.com/tf/c57e9072966712089cee
# https://github.com/mperham/sidekiq/wiki/Problems-and-Troubleshooting#cannot-find-modelname-with-id12345
# Make sure no jobs are enqueued from a rolled back
# transaction.
#
# Note the after_transaction yields immediately if there is no open
# transcation.

require 'ar_after_transaction'
require 'resque'

Resque.class_eval do
  class << self
    alias_method :enqueue_without_transaction, :enqueue
    def enqueue(*args)
      if Resque.inline?
        enqueue_without_transaction(*args)
      else
        ActiveRecord::Base.after_transaction do
          enqueue_without_transaction(*args)
        end
      end
    end
  end
end
