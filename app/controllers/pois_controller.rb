class PoisController < ApplicationController

  def load_events_from_calendar(cal_path)
    resp = Net::HTTP.get("www.google.com", cal_path)
    
    cals = Icalendar.parse(resp)
    cals.each do |cal|
      cal.events.each do |ev|
        begin
          poi = Poi.where(title: ev.location).first
          if poi
            old_event = Event.find_by_gcalendar_uid(ev.uid)

            if old_event
              puts "Updating event..."
              old_event.update_attributes(starts_at: ev.dtstart, ends_at: ev.dtend, 
                summary: ev.summary.force_encoding("UTF-8"), description: ev.description.force_encoding("UTF-8"), 
                gcalendar_uid: ev.uid)
            else
              poi.events.new(starts_at: ev.dtstart, ends_at: ev.dtend, 
                summary: ev.summary.force_encoding("UTF-8"), description: ev.description.force_encoding("UTF-8"), 
                gcalendar_uid: ev.uid).save
            end
          end
        rescue
          puts "Error importing event #{ev}"
        end
        
      end
    end
  end

  @@last_gcalendar_update = Time.at(0)

  # GET /pois
  # GET /pois.json
  def index
    if (Time.now - @@last_gcalendar_update).to_i > 3600
      Thread::start do
        load_events_from_calendar("/calendar/ical/enkarplan.org_j2njaqb2eapip42l32br00afgo%40group.calendar.google.com/public/basic.ics")
        
        load_events_from_calendar("/calendar/ical/enkarplan.org_bhfbtue1pklla91t4u97m9ggno%40group.calendar.google.com/public/basic.ics")
        
        load_events_from_calendar("/calendar/ical/enkarplan.org_5up3mopev5gkg9k17rcijrj0p4%40group.calendar.google.com/public/basic.ics")
      end
    end
  
    if params[:near]
      near = params[:near].split(',')
      latitude = near[0].to_f
      longitude = near[1].to_f
      
      params[:page] = params[:page] || 0
      params[:limit] = params[:limit] || 10
      
      @pois = Poi.find_by_sql ["select *, abs(latitude-(?))+abs(longitude-(?)) as 'distance' from pois order by distance asc limit ?, ?;", latitude, longitude, (params[:page].to_i - 1) * params[:limit].to_i, params[:limit].to_i]
    else
      @pois = Poi.order('created_at desc').page(params[:page]).per(params[:limit] || 10) 
    end
    
    if params[:type]
      @pois = @pois.where('poi_type_id = ?', params[:type])
    end
    
    if params[:search]
      search = "%" + params[:search].sub(" ", "%") + "%"
      @pois = @pois.where('title like ? OR title_eu like ?', search, search)
    end
  
    @verfied = Poi.where('is_verified = ?', true)
    @top_pois = Poi.order('rating desc').limit(4)
    @last_pois = Poi.order('created_at desc').limit(4)
    @next_events = Event.where('ends_at > ?', Time.now).order('starts_at asc').limit(8)
    @last_photos = Photo.where(is_visible_on_index: true).order('created_at desc').limit(8)
    @last_comments = Comment.order('created_at desc').limit(10)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pois }
    end
  end
  
  # GET /pois/last_updates.json
  def last_updates
    @verified = Poi.where('is_verified = ?', true)
    @top_pois = Poi.order('rating desc').limit(4)
    @last_pois = Poi.order('created_at desc').limit(4)
    @next_events = Event.where('ends_at > ?', Time.now).order('starts_at asc').limit(5)
    @last_photos = Photo.order('created_at desc').limit(4)
    @last_comments = Comment.order('created_at desc').limit(5)
    
    respond_to do |format|
      format.json { render json: {
        top_pois: @top_pois, last_pois: @last_pois, next_events: @next_events,
        last_photos: @last_photos, last_comments: @last_comments, verified: @verified
      }}
    end
  end
  
  # GET /all
  # GET /all.js
  def all
    params[:order] = params[:order] ? params[:order].to_i : 0
    
    @pois = Poi
    
    if params[:title] && !params[:title].empty?
      search = "%" + params[:title].sub(" ", "%") + "%"
      @pois = @pois.where('title like ? OR title_eu like ?', search, search)
    end
    
    if params[:type] && params[:type] != "null"  && !params[:type].empty?
      @pois = Poi.where('poi_type_id = ?', params[:type])
    end

    if params[:city] && params[:city].empty?
      @pois = @pois.where('city_id = ?', params[:city])
    end
    
    if params[:order] == 0
      @pois = @pois.order('created_at desc')
    else
      @pois = @pois.order('rating desc')
    end
    
    @pois = @pois.page(params[:page]).per(8) 

    respond_to do |format|
      format.html # all.html.erb
      format.js # all.js.erb
    end
  end

  # GET /pois/poi+slug
  # GET /pois/poi+slug.json
  def show
    @poi = Poi.find_by_slug(params[:id])
    if !@poi
      @poi = Poi.find(params[:id].to_i)
    end
    
    if params[:event]
      @event = Event.find params[:event]
    end
    
    @events = @poi.events.where('ends_at > ?', Time.now).order('starts_at asc')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @poi }
    end
  end
  
  # GET /pois/new
  # GET /pois/new.json
  def new
    @poi = Poi.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @poi }
    end
  end

  # GET /pois/poi+slug/edit
  def edit
    @poi = Poi.find_by_slug(params[:id])
    
   unless current_admin_user || @poi.user == current_user
     redirect_to poi_url(@poi)
   end
  end

  # POST /pois
  # POST /pois.json
  def create
    poi_hash = params[:poi]
    poi_hash[:user_id] = session[:current_user_id]
    poi_hash[:rating] = 0
    poi_hash[:ratings_count] = 0
    poi_hash[:slug] = poi_hash[:title].to_slug
    
    @poi = Poi.new poi_hash
    
    if params[:gpx_file]
      create_route_from_gpx(@poi, params[:gpx_file].tempfile)
    end

    respond_to do |format|
      if @poi.save
        format.html { redirect_to poi_url(@poi), notice: 'Poi was successfully created.' }
        format.json { render json: @poi, status: :created, location: @poi }
      else
        format.html { render action: "new" }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pois/poi+slug
  # PUT /pois/poi+slug.json
  def update
    @poi = Poi.find(params[:id])
    
    unless current_admin_user || @poi.user == current_user
      redirect_to poi_url(@poi)
    end

    respond_to do |format|
      if @poi.update_attributes(params[:poi])
        format.html { redirect_to poi_url(@poi), notice: 'Poi was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pois/poi+slug
  # DELETE /pois/poi+slug.json
  def destroy
    @poi = Poi.find_by_slug(params[:id])
    
    unless current_admin_user || @poi.user == current_user
      redirect_to poi_url(@poi)
    end
    
    @poi.destroy

    respond_to do |format|
      format.html { redirect_to pois_url }
      format.json { head :ok }
    end
  end
  
  #GET pois/calendar
  def calendar
    @pois = Poi.all
    
  end
end
