class SetPrecisionToRoutesAndRating < ActiveRecord::Migration
  def change
    change_column :ratings, :rating, :decimal, :precision => 3, :scale => 1
    change_column :pois, :rating, :decimal, :precision => 3, :scale => 1
    change_column :route_points, :latitude, :decimal, :precision => 16, :scale => 8
    change_column :route_points, :longitude, :decimal, :precision => 16, :scale => 8
  end
end
