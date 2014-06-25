class AddLongitudeAndLatitudeToZillows < ActiveRecord::Migration
  def change
    add_column :zillows, :longitude, :decimal
    add_column :zillows, :latitude, :decimal
  end
end
