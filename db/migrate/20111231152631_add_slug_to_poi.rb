class AddSlugToPoi < ActiveRecord::Migration
  def change
    change_table :pois do |t|
      t.string :slug
    end
    add_index :pois, :slug
    
  end
end
