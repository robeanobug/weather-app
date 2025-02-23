class AddWeatherDataToLocations < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float
    add_column :locations, :max_temperature, :float
    add_column :locations, :min_temperature, :float
  end
end
