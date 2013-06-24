class AddBasqueLang < ActiveRecord::Migration
  def change
    change_table :poi_types do |t|
      t.string :name_eu
    end

    change_table :pois do |t|
      t.string :title_eu
      t.text :description_eu
    end
  end
end
