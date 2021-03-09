require 'rails_helper'

RSpec.describe ForecastFacade, :vcr do
  before(:each) do
    @location = 'mountain view, ca'
    @map      = MapService.coordinates_by_location(@location)
    @lat      = @map[:results][0][:locations][0][:latLng][:lat]
    @lng      = @map[:results][0][:locations][0][:latLng][:lng]
    @weather  = WeatherService.get_weather(@lat, @lng)
  end

  it 'returns a Forcast object from a given location' do
    forecast = ForecastFacade.forecast(@location)

    expect(forecast).to be_a Forecast
    expect(forecast.current_weather).to be_a CurrentWeather
    expect(forecast.daily_weather[0]).to be_a DailyWeather
    expect(forecast.hourly_weather[0]).to be_a HourlyWeather

    expect(forecast.current_weather.temperature).to be_a Float
    expect(forecast.current_weather.conditions).to be_a String
    expect(forecast.hourly_weather).to be_an Array
    expect(forecast.daily_weather).to be_an Array

    expect(forecast.daily_weather.count).to eq(5)
    expect(forecast.hourly_weather.count).to eq(8)
  end

  it 'can call weather for multiple service calls' do
    expect(@weather).to be_a Hash
    check_hash_structure(@weather, :lat, Float)
    check_hash_structure(@weather, :lon, Float)
    check_hash_structure(@weather, :current, Hash)
    check_hash_structure(@weather, :hourly, Array)
    check_hash_structure(@weather, :daily, Array)
  end

  it 'can get many HourlyWeather objects' do
    hourly_weather = ForecastFacade.hourly_weather(@weather)

    expect(hourly_weather).to be_an Array
    expect(hourly_weather[0]).to be_an HourlyWeather
    expect(hourly_weather[0].conditions).to be_a String
    expect(hourly_weather[0].icon).to be_a String
    expect(hourly_weather[0].temperature).to be_a Float
    
    expect(hourly_weather.count).to eq(8)
  end

  it 'can get DailyWeather objects' do
    daily_weather = ForecastFacade.daily_weather(@weather)
    first_day     = daily_weather[0]

    expect(daily_weather).to be_an Array
    expect(first_day).to be_an DailyWeather
    expect(first_day.conditions).to be_a String
    expect(first_day.icon).to be_a String
    expect(first_day.date).to be_a String
    expect(first_day.max_temp).to be_a Float
    expect(first_day.min_temp).to be_a Float
    expect(first_day.sunrise).to be_a Time
    expect(first_day.sunset).to be_a Time
    
    expect(daily_weather.count).to eq(5)
  end
end
