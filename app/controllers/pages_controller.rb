class PagesController < ApplicationController
  
  # GET /events
  # GET /events.json
  def index
  
    @events = Poi.order('created_at desc').page(params[:page]).per(params[:limit] || 10) 
    
    if params[:type]
      @events = @events.where('poi_type_id = ?', params[:type])
    end
    
    if params[:search]
      search = "%" + params[:search].sub(" ", "%") + "%"
      @events = @events.where('title like ? OR title_eu like ?', search, search)
    end
  
    @verfied = Event.where('is_verified = ?', true)
    @top_pois = Event.order('rating desc').limit(4)
    @last_pois = Event.order('created_at desc').limit(4)
    @next_events = Event.where('ends_at > ?', Time.now).order('starts_at asc').limit(8)
    @last_photos = Photo.where(is_visible_on_index: true).order('created_at desc').limit(8)
    @last_comments = Comment.order('created_at desc').limit(10)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pois }
    end
  end
  
end
