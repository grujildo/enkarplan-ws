class RatingsController < ApplicationController

  # POST /ratings.json
  def create
    @rating = Rating.new(params[:rating])
    
    #update event's rating
    event = @rating.event
    
    old_rating = event.rating || 0
    old_ratings_count = event.ratings_count || 0
    
    new_rating = (old_rating * old_ratings_count + @rating.rating) / (old_ratings_count + 1)
    
    event.rating = new_rating
    event.ratings_count = old_ratings_count + 1
    
    event.update_attributes rating: new_rating, ratings_count: (old_ratings_count + 1)

    respond_to do |format|
      if @rating.save
        format.json { render json: {rating: new_rating, ratings_count: (old_ratings_count + 1)}, status: :created, location: @rating }
      else
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

end
