class AddIndexVisibilityToPhoto < ActiveRecord::Migration
  def change
    change_table :photos do |t|
      t.boolean :is_visible_on_index, default: false
    end
  end
end
