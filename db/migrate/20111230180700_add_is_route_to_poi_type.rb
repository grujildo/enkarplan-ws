class AddIsRouteToPoiType < ActiveRecord::Migration
  def change
    change_table :poi_types do |t|
      t.boolean :is_route, default: false
    end
  end
end
