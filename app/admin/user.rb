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
    actions do |user|
      link_to 'Approve', approve_admin_user_path(user),
              class: "member_link", remote: true, method: :put,
              data: { confirm: "Are you sure to approve?" }
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :email
    end
    f.actions
  end

  member_action :approve, method: :put do
    if resource.update_attribute(:approved, true)
      UserSignUpMailer.delay.admin_approved(resource)
      redirect_to resource_path, notice: "Approved!"
    else
      redirect_to resource_path, notice: "Failed! #{resource.errors.full_messages.join(', ')}"
    end
  end
end
