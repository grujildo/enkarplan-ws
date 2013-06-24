class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :type
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :rating
      t.integer :ratings_count

      t.timestamps
    end
  end
end
