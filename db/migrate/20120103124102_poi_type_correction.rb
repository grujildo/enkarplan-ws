class PoiTypeCorrection < ActiveRecord::Migration
  def change
    rename_column :pois, :type, :poi_type_id
  end

end
