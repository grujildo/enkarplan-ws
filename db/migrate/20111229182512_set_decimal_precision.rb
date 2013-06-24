class SetDecimalPrecision < ActiveRecord::Migration
  def change
    change_column :pois, :latitude, :decimal, :precision => 16, :scale => 8
    change_column :pois, :longitude, :decimal, :precision => 16, :scale => 8
  end
end
