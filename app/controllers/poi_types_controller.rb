class PoiTypesController < ApplicationController

  # GET /poi_types.json
  def index
    @poi_types = PoiType.all

    respond_to do |format|
      format.json { render json: @poi_types }
    end
  end

  # GET /poi_types/1.json
  def show
    @poi_type = PoiType.find(params[:id])
    
    respond_to do |format|
      format.json { render json: @poi_type }
    end
  end
end
