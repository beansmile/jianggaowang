ActiveAdmin.register User do
  permit_params :name, :email, :password, :password_confirmation

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

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
