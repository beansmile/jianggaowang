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
    Slide.find_each do |slide|
      slide.slug = nil
      if slide.save
        puts "[SUCC] Updated #{slide.title}"
      else
        puts "[FAIL] #{slide.title}'s errors: #{slide.errors.full_messages.join(',' )}"
      end
    end
    Event.find_each do |event|
      event.slug = nil
      if event.save
        puts "[SUCC] Updated #{event.header}"
      else
        puts "[FAIL] #{event.header}'s errors: #{event.errors.full_messages.join(',' )}"
      end
    end
  end

  desc 'Generate tags for exist events'
  task :generate_tags_for_exist_evetns => :environment do
    Event.find_each do |event|
      event_tags = []
      event.slides.each do |s|
        event_tags.concat s.tag_list
      end

      event.tag_list.add event_tags.uniq
      if event.save
        puts "[SUCC] Set #{event.header} tags to #{event.tag_list}"
      else
        puts "[ERROR] #{event.errors.full_messages.join(', ')}"
      end
    end
  end
end
