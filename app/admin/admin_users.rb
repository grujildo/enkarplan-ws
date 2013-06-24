ActiveAdmin.register AdminUser do
  
  index do  
    column :id  
    column :email
    column :reset_password_sent_at
    column :current_sign_in_at
    column :current_sign_in_ip
    column :created_at
    
    default_actions
  end
  
  form do |f|
    f.inputs "Detalles" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.buttons
    end
  
end
