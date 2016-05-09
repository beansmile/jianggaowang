namespace :hotfix do
  desc 'Set author for exist slides'
  task :set_author_for_exist_slide => :environment do
    Slide.find_each do |slide|
      if slide.update_attribute :author, slide.user.name
        puts "[SUCC] Updated #{slide.title}"
      else
        puts "[FAIL] #{slide.title}'s errors: #{slide.errors.full_messages.join(', ')}"
      end
    end
  end

  desc 'Approve exist users'
  task :approve_exist_users => :environment do
    User.find_each do |user|
      user.update_attribute :approved_at, Time.current
    end
  end

  desc 'Generate friendly id for exist events and slides'
  task :generate_friendly_id_for_exist_events_and_slide => :environment do
    Slide.find_each(&:save)
    Event.find_each(&:save)
  end
end
