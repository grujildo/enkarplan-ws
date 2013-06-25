class City < ActiveRecord::Base
  extend FriendlyId
  
  has_many :pois
  
  friendly_id :title, use: :slugged
  
  geocoded_by :name
  
  after_validation :geocode, :set_location, :if => :name_changed?
  
  def set_location
    results = Geocoder.search(self.name)
    if geo = results.first
      self.latitude = geo.latitude
      self.longitude = geo.longitude
    end
  end
  
end
