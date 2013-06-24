ActiveAdmin.register Poi do

  action_item do
    link_to "Importar desde GPX", "/admin/pois/import_gpx"
  end

  collection_action :import_gpx
  
  collection_action :submit_gpx, method: :post do
    begin
      gpx = GPX::GPXFile.new gpx_file: params[:gpx_file].tempfile.path
      
      pois_count = 0
      if gpx.tracks
        gpx.tracks.each do |track|
          track_poi = Poi.new title: track.name, description: track.name, user_id: session[:current_user_id], 
            latitude: track.points.first.lat, longitude: track.points.first.lon, rating: 0, ratings_count: 0
          track_poi.save!
          
          track.points.each do |route_point|
            track_poi.route_points.new(latitude: route_point.lat, longitude: route_point.lon).save!
          end
          pois_count += 1
        end
      end
      
      if gpx.routes
        gpx.routes.each do |track|
          track_poi = Poi.new title: track.name, description: track.name, user_id: session[:current_user_id], 
            latitude: track.points.first.lat, longitude: track.points.first.lon, rating: 0, ratings_count: 0
          track_poi.save!
          
          track.points.each do |route_point|
            track_poi.route_points.new(latitude: route_point.lat, longitude: route_point.lon).save!
          end
          pois_count += 1
        end
      end
      
      redirect_to '/admin/pois', notice: "GPX importado: #{pois_count} POI(s) creados"
    rescue
      redirect_to '/admin/pois/import_gpx', alert: "Fichero invalido"
    end
  end
  
  show do
    attributes_table do
      row :id
      row :slug
      row :is_verified
      row :qr_code do |p|
        image_tag "http://qrcode.kaywa.com/img.php?s=12&d=enkarplan://#{p.id}"
      end
      row :title
      row :title_eu
      row :description
      row :description_eu
      row :rating do |p|
        "#{p.rating} (#{p.ratings_count})"
      end
      row :user
      row :poi_type
      row :coordinates do |p|
        "#{p.latitude}, #{p.longitude}"
      end
      row :created_at
      row :updated_at
      
      row :photos do |poi|
        html = ""
        poi.photos.each do |p|
          html += link_to image_tag(p.image.url(:thumb)), "/admin/fotos/#{p.id}", style: "margin-left: 10px;"
        end
        html.html_safe
      end
    end
    
    attributes_table do
      row :description do |p|
        sanitize p.description if p.description
      end
      row :description_eu do |p|
        sanitize p.description_eu if p.description_eu
      end
    end
    
    attributes_table do
      row :map do |p|
        html = '<div id="map-canvas" style="width: 800px; height: 450px; margin: 22px 0 30px -5px; display: block; clear: both;"></div>'
        html += "<script>var poi = #{ p.to_json.html_safe };</script>"
        html += javascript_include_tag "http://maps.googleapis.com/maps/api/js?sensor=false"
        html += javascript_include_tag "show-poi-map"
        html.html_safe
      end
    end
  end

  index do 
    column :id 
    column :title  
    column :title_eu
    column :user
    column :description do |poi|
      truncate strip_tags(poi.description_plain)
    end  
    column :rating do |poi|
      "#{poi.rating} (#{poi.ratings_count})"
    end
    column :coordinates do |poi|
      "#{poi.latitude}, #{poi.longitude}"
    end
    column :slug
    column :created_at
    default_actions
  end  
end
