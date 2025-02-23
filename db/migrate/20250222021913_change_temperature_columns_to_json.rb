class ChangeTemperatureColumnsToJson < ActiveRecord::Migration[8.0]
  def change
    change_column :locations, :max_temperatures, :json, default: []
    change_column :locations, :min_temperatures, :json, default: []
  end
end
