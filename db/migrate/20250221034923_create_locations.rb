class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :zip_code

      t.timestamps
    end
  end
end
