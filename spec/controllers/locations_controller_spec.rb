require 'rails_helper'
require 'webmock/rspec'

# These test do not work but this was my attempt.

RSpec.describe LocationsController, type: :controller do
  describe "POST #create" do
    let(:zip_code) { "27545" }
    let(:mock_geo_response) { { "latt" => 35.778744, "longt" => -78.504425 } }
    let(:mock_weather_response) do
      {
        max_temps: [48.9, 54.0, 58.8, 66.9, 66.4, 60.8, 56.3],
        min_temps: [16.9, 28.6, 32.7, 42.8, 46.7, 44.0, 39.2]
      }
    end

    before do
      # Mock the geocode API response for the given zip code
      stub_request(:get, "https://geocode.xyz/#{zip_code}?json=1&auth=#{ENV['GEOCODE_API_KEY']}").
        to_return({"latitude" => 35.778744, "longitude" => -78.504425})

      # Mock the weather API response
      stub_request(:get, "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York").
        to_return("daily"=>{ "temperature_2m_max"=>[48.9, 54.0, 58.8, 66.9, 66.4, 60.8, 56.3], "temperature_2m_min"=>[16.9, 28.6, 32.7, 42.8, 46.7, 44.0, 39.2]})

      post :create, params: { location: { zip_code: zip_code } }
    end

    it "fetches and assigns the correct coordinates from geocode" do
      location = assigns(:location)
      expect(location.latitude).to eq(mock_geo_response["latt"])
      expect(location.longitude).to eq(mock_geo_response["longt"])
    end

    it "fetches and assigns the correct weather data" do
      location = assigns(:location)
      expect(location.max_temperatures).to eq(mock_weather_response[:max_temps])
      expect(location.min_temperatures).to eq(mock_weather_response[:min_temps])
    end
  end
end
