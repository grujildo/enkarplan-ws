class EventsController < ApplicationController
  
  # GET /events.json
  def index
    if params[:all] == true
      @events = Event.all?
    end
    
    if params[:from] && params[:to]
      @events = Event.where('starts_at < ? AND ends_at > ?', params[:to], params[:from])
    end

    respond_to do |format|
      format.json { render json: @events }
    end
  end
  
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
    @top_events = Event.order('rating desc').limit(4)
    @last_events = Event.order('created_at desc').limit(4)
    @next_events = Event.where('ends_at > ?', Time.now).order('starts_at asc').limit(8)
    @last_photos = Photo.where(is_visible_on_index: true).order('created_at desc').limit(8)
    @last_comments = Comment.order('created_at desc').limit(10)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.json { render json: @event }
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.json { render json: @event, status: :created, location: @event }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

end
