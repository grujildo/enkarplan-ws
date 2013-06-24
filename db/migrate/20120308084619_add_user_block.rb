class AddUserBlock < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :is_banned, default: false
    end
  end
end
