class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale
  before_filter :api_call
  
  helper_method :current_user  
  
  def poi_url(poi)
    "/#{t 'resources.pois'}/#{poi.slug}"
  end
  
  def api_call
    
    if request.host.split('.').first == 'api'
      puts request.host.split('.').first
      
    
      params[:format] = :json
      
      if !params[:api_key]
        head :forbidden
        false
      end
      
      api_key = ApiKey.find_by_key(params[:api_key])
      if !api_key
        head :forbidden
        false
      else
        api_key.calls_count = api_key.calls_count + 1
        api_key.save
      end
    end
    true
  end
  
  def set_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end
    
    I18n.locale = session[:locale] || I18n.default_locale
  end
  
  def current_user
    User.find(session[:current_user_id]) if session[:current_user_id]
  end
  
end
