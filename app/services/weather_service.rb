class WeatherService
  require 'httparty'

  def self.fetch_weather(latitude, longitude)
    weather_api_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York"

    response = HTTParty.get(weather_api_url)

    parsed_data = response.parsed_response
    return nil unless parsed_data

    max_temps = parsed_data.dig('daily', 'temperature_2m_max')
    min_temps = parsed_data.dig('daily', 'temperature_2m_min')

    { max_temps: max_temps, min_temps: min_temps }
  end
end