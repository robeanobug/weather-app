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
    get_coordinates
    get_weather
    
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
        get_coordinates
        get_weather
      end
      @location.save
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

  def get_coordinates
    coordinates = GeocodeService.fetch_coordinates(@location.zip_code)

    if coordinates
      @location.latitude = coordinates[:latitude]
      @location.longitude = coordinates[:longitude]
    else
      flash[:error] = coordinates[:error]
      render :edit, status: :unprocessable_entity and return
    end
  end

  def get_weather
    weather_data = WeatherService.fetch_weather(@location.latitude, @location.longitude)
    if weather_data
      @location.max_temperatures = weather_data[:max_temps]
      @location.min_temperatures = weather_data[:min_temps]
    else
      flash[:error] = "Unable to fetch weather data"
      render :edit, status: :unprocessable_entity and return
    end
  end
end
