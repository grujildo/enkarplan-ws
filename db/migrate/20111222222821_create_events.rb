class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :poi_id
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
