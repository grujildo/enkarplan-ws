class RemoveUnnecessaryFields < ActiveRecord::Migration
  def change
    remove_column :api_keys, :updated_at
    remove_column :api_keys, :created_at
    remove_column :route_points, :updated_at
    remove_column :route_points, :created_at
    remove_column :photos, :updated_at
    remove_column :comments, :updated_at
    remove_column :events, :updated_at
    remove_column :ratings, :updated_at
  end
end
