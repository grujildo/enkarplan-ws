class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :poi_id
      t.string :title
      t.integer :user_id
      t.integer :type
      t.decimal :latitude, :decimal, :precision => 16, :scale => 8
      t.decimal :longitude, :decimal, :precision => 16, :scale => 8
      t.decimal :rating
      t.integer :ratings_count
      t.integer :city_id
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :address
      t.string :slug
      t.string :description
      t.boolean :is_verified
      t.integer :poi_type_id

      t.timestamps
    end
  end
end
