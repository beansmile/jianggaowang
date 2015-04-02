ActiveAdmin.register User do
  index do
    selectable_column
    column :id, :name, :bio, :email
    column :avatar do |user|
      image_tag user.avatar.url.gsub(/\A\/assets/, '')
    end
    actions
  end
end
