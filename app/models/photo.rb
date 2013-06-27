class Photo < ActiveRecord::Base
  has_attached_file :image, styles: { full: "1024x768>", gallery: "910x300#", thumb: "100x100#", icon_2x: "140x140#", icon: "70x70#" }, 
    url: "/photo/:hash.:extension",
    hash_secret: "(%^{R8'PH.~12mFL#f:#5<=K*'Xx$@"
  belongs_to :poi
  belongs_to :event
  belongs_to :user
  
  def as_json options=nil
      options ||= {}
      options[:methods] = ((options[:methods] || []) + [:image_urls])
      super options
    end
  
  def image_urls
    { 
      full: self.image.url(:full),
      thumb: self.image.url(:thumb),
      icon_2x: self.image.url(:icon_2x),
      icon: self.image.url(:icon)
    }
  end
  
end
