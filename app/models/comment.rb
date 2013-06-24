class Comment < ActiveRecord::Base
  belongs_to :poi
  belongs_to :user
  
  def as_json options=nil
      options ||= {}
      options[:methods] = ((options[:methods] || []) + [:user_name, :poi_slug, :poi_title])
      super options
    end
  
  def user_name
    user.name if user
  end
  
  def poi_slug
    poi.slug if poi
  end
  
  def poi_title
    poi.title if poi
  end
  
end
