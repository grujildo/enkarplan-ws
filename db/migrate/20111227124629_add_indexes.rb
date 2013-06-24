class AddIndexes < ActiveRecord::Migration
  def change
    add_index :authentications, :provider
    add_index :authentications, :uid
  end
end
