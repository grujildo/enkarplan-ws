class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :description
      t.string :key
      t.integer :calls_count, default: 0

      t.timestamps
    end
    
    add_index :api_keys, :key, unique: true
  end
end
