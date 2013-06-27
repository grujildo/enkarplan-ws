class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :poi_id
      t.integer :user_id
      t.text :comment
      t.integer :event_id

      t.timestamps
    end
  end
end
