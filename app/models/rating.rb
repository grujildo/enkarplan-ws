class Rating < ActiveRecord::Base
  belongs_to :poi
  belongs_to :user
  
  validates :poi_id, :presence => true
end
