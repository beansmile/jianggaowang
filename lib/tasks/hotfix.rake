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
end
