ActiveAdmin.register PoiType, as: "Categorias" do

  index do  
    column :name
    column :name_eu
    column :image do |pt|
      image_tag pt.image.url(:med)
    end  
    column :is_route
    
    default_actions
  end 
  
  form :html => { :enctype => "multipart/form-data" } do |f|
     f.inputs "Poi Type" do
      f.input :name
      f.input :name_eu
      f.input :is_route
      f.input :is_special
      f.input :image, :as => :file
    end
    f.buttons
  end
  
end
