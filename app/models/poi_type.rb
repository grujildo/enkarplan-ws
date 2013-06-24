class PoiType < ActiveRecord::Base
  has_attached_file :image, styles: { big: "128x128#", med: "64x64#", small: "32x32#" }, 
    url: "/poi_type_img/:hash.:extension",
    hash_secret: "2L_.##5|!+;&)%T;!R1T)_<)5^1/2k"
    
  has_many :pois
  
  def as_json options=nil
      options ||= {}
      options[:methods] = ((options[:methods] || []) + [:image_urls])
      super options
    end
  
  def image_urls
    { 
      big: self.image.url(:big),
      med: self.image.url(:med),
      small: self.image.url(:small)
    }
  end

  def localized_name(locale)
    if (locale == 'eu' || locale == 'eu_ES') && self.name_eu && self.name_eu.length > 0
      self.name_eu
    else
      self.name
    end
  end
  
end
