class Event < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :poi_type
  belongs_to :poi
  belongs_to :user
  belongs_to :city
  has_many :photos, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  
  friendly_id :title, use: :slugged
  
  validates :title, :presence => true
  validates :description, :presence => true
  validates_uniqueness_of :slug
  
  validates_presence_of :starts_at
  validates_presence_of :ends_at
  
  def poi_slug
    poi.slug
  end
  
  def poi_title
    poi.title
  end
  
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:poi_type, :last_comments, :last_photos, :user_name, :description_plain, :description_plain_eu])
    super options
  end
  
  def description_plain
    Nokogiri::HTML(self.description).text if self.description
  end
  
  def description_plain_eu
    Nokogiri::HTML(self.description_eu).text if self.description_eu
  end
  
  def localized_description(locale)
    if (locale == 'eu' || locale == 'eu_ES') && self.description_eu && self.description_eu.length > 0
      self.description_eu
    else
      self.description
    end
  end
  
  def localized_title(locale)
    if (locale == 'eu' || locale == 'eu_ES') && self.title_eu && self.title_eu.length > 0
      self.title_eu
    else
      self.title
    end
  end
  
end
