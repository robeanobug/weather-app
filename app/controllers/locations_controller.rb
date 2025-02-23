class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]

  def index
    @locations = Location.all
  end

  def show
    # converts json string of temps back to array
    @location.convert_temperatures_to_array
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)

    coordinates = get_coordinates(@location.zip_code)

    # ensures coordinates are present and assigns to the loation
    if coordinates
      @location.latitude = coordinates[:latitude]
      @location.longitude = coordinates[:longitude]
    else
      flash[:error] = "Unable to fetch coordinates"
      render :new, status: :unprocessable_entity and return
    end

    # gets forecasted temperatures for our location from API open-meteo
    temps = fetch_weather(@location.latitude, @location.longitude)

    @location.max_temperatures = temps[:max_temps] || []
    @location.min_temperatures = temps[:min_temps] || []

    if @location.save
      redirect_to @location
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    zip_changed = params[:location][:zip_code] != @location.zip_code
    
    # if new zip code update the location's coordinates
    if @location.update(location_params)
      if zip_changed
        coordinates = get_coordinates(@location.zip_code)
        if coordinates
          @location.latitude = coordinates[:latitude]
          @location.longitude = coordinates[:longitude]
  
          # Fetch new weather data and save it
          weather_data = fetch_weather(@location.latitude, @location.longitude)
          if weather_data
            @location.max_temperatures = weather_data[:max_temps]
            @location.min_temperatures = weather_data[:min_temps]
            @location.save
          else
            flash[:error] = "Unable to fetch weather data"
            render :edit, status: :unprocessable_entity and return
          end
        else
          flash[:error] = "Unable to fetch coordinates"
          render :edit, status: :unprocessable_entity and return
        end
      end
  
      redirect_to @location, notice: "Location updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.expect(location: [ :zip_code ])
  end

  def get_coordinates(zip_code)
    api_key = ENV['GEOCODE_API_KEY']
    geo_api_url = "https://geocode.xyz/#{zip_code}?json=1&auth=#{api_key}"
    response = HTTParty.get(geo_api_url)
    puts "Geocode's API response is: #{response}"
    puts "Latitide: #{response["latt"]}"
    puts "Longitude: #{response["longt"]}"

    if response.success?
      { latitude: response["latt"], longitude: response["longt"] }
    end
  end

  def fetch_weather(latitude, longitude)
    weather_api_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timezone=America%2FNew_York"

    response = HTTParty.get(weather_api_url)
    puts "The weather's response is: #{response.inspect}"
    
    return nil unless response.success?

    parsed_data = response.parsed_response
    puts "The weather's parsed response is: #{parsed_data.inspect}"

    max_temps = parsed_data.dig('daily', 'temperature_2m_max')
    min_temps = parsed_data.dig('daily', 'temperature_2m_min')

    puts "max_temps: #{max_temps.inspect}"
    puts "min_temps: #{min_temps.inspect}"

    { max_temps: max_temps, min_temps: min_temps }
  end
end
