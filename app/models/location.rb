class Location < ApplicationRecord
  validates :zip_code, presence: true

  VALID_ZIP_REGEX = /\A\d{5}\z/
  validates :zip_code, format: { with: VALID_ZIP_REGEX, message: "must be exactly 5 digits" }

  before_save :convert_temperatures_to_json
  after_find :convert_temperatures_to_json
  
  def convert_temperatures_to_array
    self.max_temperatures = JSON.parse(max_temperatures) if max_temperatures.is_a?(String)
    self.min_temperatures = JSON.parse(min_temperatures) if min_temperatures.is_a?(String)
  end

  private

  def convert_temperatures_to_json
    self.max_temperatures = max_temperatures.to_json if max_temperatures.is_a?(Array)
    self.min_temperatures = min_temperatures.to_json if min_temperatures.is_a?(Array)
  end
end
