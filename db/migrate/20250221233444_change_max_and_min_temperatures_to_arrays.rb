class ChangeMaxAndMinTemperaturesToArrays < ActiveRecord::Migration[8.0]
  def change
    change_column :locations, :max_temperatures, :text, default: "[]"
    change_column :locations, :min_temperatures, :text, default: "[]"
  end
end
