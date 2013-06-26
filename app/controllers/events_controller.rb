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
  
    @events = Event.order('created_at desc').page(params[:page]).per(params[:limit] || 10) 
    
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
  
  # GET /all
  # GET /all.js
  def all
    params[:order] = params[:order] ? params[:order].to_i : 0
    
    @events = Event
    
    if params[:title] && !params[:title].empty?
      search = "%" + params[:title].sub(" ", "%") + "%"
      @events = @events.where('title like ? OR title_eu like ?', search, search)
    end
    
    if params[:type] && params[:type] != "null"  && !params[:type].empty?
      @events = Event.where('poi_type_id = ?', params[:type])
    end

    if params[:order] == 0
      @events = @events.order('created_at desc')
    else
      @events = @events.order('rating desc')
    end
    
    @events = @events.page(params[:page]).per(8) 

    respond_to do |format|
      format.html # all.html.erb
      format.js # all.js.erb
    end
  end

  # GET /events/1.json
  def show
    @event = Event.find_by_slug(params[:id])
    if !@event
      @event = Event.find(params[:id].to_i)
    end
    
    if params[:event]
      @event = Event.find params[:event]
    end
    
    @events = @event.events.where('ends_at > ?', Time.now).order('starts_at asc')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end
  
  # GET /events/event+slug/edit
  def edit
    @event = Event.find_by_slug(params[:id])
    
   unless current_admin_user || @event.user == current_user
     redirect_to event_url(@event)
   end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end
  
  # POST /events
  # POST /events.json
  def create
    event_hash = params[:event]
    event_hash[:user_id] = session[:current_user_id]
    event_hash[:rating] = 0
    event_hash[:ratings_count] = 0
    
    @event = Event.new event_hash

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

end
