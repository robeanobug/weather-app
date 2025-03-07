  class GeocodeService
    require 'httparty'

    def self.fetch_coordinates(zip_code)
      api_key = ENV['GEOCODE_API_KEY']
      geo_api_url = "https://geocode.xyz/#{zip_code}?json=1&auth=#{api_key}"
      response = HTTParty.get(geo_api_url)
  
      if response.success?
        unless response["latt"] == "0.00000" && response["longt"] == "0.00000"
          { latitude: response["latt"], longitude: response["longt"] }
        else
          return { error: "Unable to fetch coordinates" }
        end
      end
    end
  end
