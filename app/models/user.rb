class User < ActiveRecord::Base
  has_many :authentications
  
  def as_json options=nil
    options ||= {}
    options[:only] = [:name]
    options[:methods] = ((options[:methods] || []) + [:provider])
    super options
  end
  
  def provider
    authentications[0].provider if authentications && authentications.count > 0
  end
end
