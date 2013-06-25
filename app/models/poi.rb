class Poi < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :poi_type
  belongs_to :user
  belongs_to :city
  has_many :photos, :dependent => :delete_all
  has_many :events, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  has_many :route_points, :dependent => :delete_all
  
  friendly_id :title, use: :slugged
  
  validates :title, :presence => true
  validates :description, :presence => true
  validates_uniqueness_of :slug
  
  attr_accessor :route_points_list
  
  after_save :save_route_points
  before_save :sanitize
  
  def save_route_points
    if @route_points_list
      if @route_points_list.kind_of?(Array)
        @route_points_list.each do |route_point| 
          self.route_points.new(route_point).save
        end
      else
        @route_points_list.each do |index, route_point| 
          self.route_points.new(route_point).save
        end
      end
    end
  end
  
  def sanitize
    self.description = ActionController::Base.helpers.sanitize self.description, tags: %w(b i h1 h2 h3 h4 h5 h6 table tr td p div ul ol li iframe img a)
    self.description_eu = ActionController::Base.helpers.sanitize self.description_eu, tags: %w(b i h1 h2 h3 h4 h5 h6 table tr td p div ul ol li iframe img a)
  end
  
  def generate_slug
    if self.title && self.title.length > 0
      title = self.title
    else
      title = self.title_eu
    end
    self.slug = title.without_accents.to_slug
  end

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:poi_type, :last_comments, :last_photos, :user_name, :next_events, :route_points, :description_plain, :description_plain_eu])
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
  
  def user_name
    self.user.name if self.user
  end
  
  def next_events
    events.where('ends_at > ?', Time.now).order('starts_at asc').limit(10)
  end
  
  def last_comments
    comments.order('created_at desc').limit(10)
  end
  
  def last_photos
    photos.order('created_at desc').limit(10)
  end
  
end
