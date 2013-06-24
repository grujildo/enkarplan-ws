class AddIndexesToEvent < ActiveRecord::Migration
  def change
    add_index :events, :starts_at
    add_index :events, :ends_at
  end
end
