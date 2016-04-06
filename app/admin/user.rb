ActiveAdmin.register User do
  permit_params :name, :email, :approved

  index do
    selectable_column
    column :id
    column :name
    column :bio
    column :email
    column :approved
    column :avatar, class: 'user-avatar' do |user|
      image_tag user.avatar.url.gsub(/\A\/assets\//, '')
    end
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :email
      f.input :approved, as: :boolean
      # TODO: Send user an email to notity him/her has been approved
    end
    f.actions
  end
end
