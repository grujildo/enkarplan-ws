class AddDescriptionToEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :summary
      t.string :gcalendar_uid
    end
    change_column :events, :description, :text
    
    add_index :events, :gcalendar_uid
  end
end
