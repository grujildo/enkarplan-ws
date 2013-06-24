class AddVerifiedPois < ActiveRecord::Migration
  def change
    change_table :pois do |t|
      t.boolean :is_verified
    end
  end
end
