class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :poi_id
      t.integer :event_id
      t.integer :user_id
      t.string :ip
      t.decimal :rating

      t.timestamps
    end
  end
end
