ActiveAdmin.register Comment, as: "Comentarios" do

  index do  
    column :comment  
    column :poi
    column :user
    column :created_at
    
    default_actions
  end
  
end
