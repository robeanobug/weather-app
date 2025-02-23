class RenameTemperatureColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :locations, :max_temperature, :max_temperatures
    rename_column :locations, :min_temperature, :min_temperatures
  end
end
