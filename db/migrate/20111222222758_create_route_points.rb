class CreateRoutePoints < ActiveRecord::Migration
  def change
    create_table :route_points do |t|
      t.integer :poi_id
      t.integer :index
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
