ActiveAdmin.register Event do
  permit_params :header, :content, :start_at, :end_at, :pinned, :editor_choice_title, :editor_choice_image

  form do |f|
    f.inputs "Admin Details" do
      f.input :header
      f.input :content
      f.input :start_at
      f.input :end_at
      f.input :editor_choice_title
      f.input :editor_choice_image, as: :file
      f.input :pinned, as: :boolean
    end
    f.actions
  end
end
