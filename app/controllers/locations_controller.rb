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
    if @location.valid?
      if get_coordinates && get_weather
        @location.save
        flash[:notice] = "Location created successfully!"
        redirect_to @location
      else
        # Flash alert when fetching coordinates or weather fails
        flash[:alert] = "Failed to fetch coordinates or weather."
        render :new, status: :unprocessable_entity
      end
    else
      # If update failed, show validation errors
      flash[:alert] = @location.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    input = params[:location][:zip_code]
    zip_changed = input != @location.zip_code
    
    if @location.update(location_params)
      if zip_changed
        if get_coordinates && get_weather
          @location.save
          flash[:notice] = "Location updated successfully!"
          redirect_to @location
        else
          # Flash error when fetching coordinatesor weather fails
          flash[:alert] = "Failed to update coordinates or weather."
          render :edit, status: :unprocessable_entity
        end
      else
        # No change in zip code, just update the location
        flash[:notice] = "Location updated successfully!"
        redirect_to @location
      end
    else
      # If update failed, show validation errors
      flash[:alert] = @location.errors.full_messages.to_sentence
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
      return true
    else
      flash[:error] = coordinates[:error]
      return false
    end
  end

  def get_weather
    weather_data = WeatherService.fetch_weather(@location.latitude, @location.longitude)
    if weather_data
      @location.max_temperatures = weather_data[:max_temps]
      @location.min_temperatures = weather_data[:min_temps]
      return true
    else
      flash[:error] = "Unable to fetch weather data"
      return false
    end
  end
end
