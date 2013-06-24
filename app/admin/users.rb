ActiveAdmin.register User, as: "Usuarios" do
  index do  
    column :name  
    column :email
    column :providers do |user|
      "#{user.authentications.first.provider if user.authentications.first}"
    end
    column :created_at
    
    default_actions
  end
end
