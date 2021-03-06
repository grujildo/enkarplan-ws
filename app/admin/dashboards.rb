ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

  section "Ultimos pois", :priority => 1 do  
    table_for Poi.order("created_at desc").limit(5) do  
      column :title do |poi|  
        link_to poi.title, admin_poi_path(poi)  if poi
      end  
      column :created_by do |poi|
        poi.user.name if poi.user
      end 
      column :created_at 
    end  
    strong { link_to "Ver todos", admin_pois_path }  
  end
  
  section "Ultimos comentarios", :priority => 10 do  
    table_for Comment.order("created_at desc").limit(5) do  
      column :poi do |comment|  
        link_to comment.poi.title, admin_poi_path(comment.poi) if comment.poi
      end  
      column :comment do |comment|
        truncate comment.comment
      end  
    end  
    strong { link_to "Ver todos", admin_comments_path }  
  end
  
  section "Ultimos usuarios", :priority => 20 do  
    table_for User.order("created_at desc").limit(5) do  
      column :name
      column :provider do |user|
        "#{user.authentications.first.provider if user.authentications.first}"
      end 
    end  
    #strong { link_to "Ver todos", admin_users_path }  
  end
end
