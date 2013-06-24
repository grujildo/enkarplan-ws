class AddSpecialCategories < ActiveRecord::Migration
  def change
    change_table :poi_types do |t|
      t.boolean :is_special, default: false
    end
  end
end
