class AddImagePaperclipToPhoto < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
    end
  end

  def self.down
    drop_attached_file :photos, :image
  end
end
