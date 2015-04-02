ActiveAdmin.register User do
  index do
    selectable_column
    column :id
    column :name
    column :bio
    column :email
    column :avatar, class: 'user-avatar' do |user|
      image_tag user.avatar.url.gsub(/\A\/assets\//, '')
    end
    actions
  end
end
