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
    forecast = ForecastFacade.get_weather(@lat, @lng)

    expect(forecast).to be_a Forecast
    expect(forecast.current_weather).to be_a CurrentWeather
    expect(forecast.current_weather.temperature).to be_a Float
    expect(forecast.current_weather.conditions).to be_a String
    expect(forecast.daily_weather).to be_an Array
    expect(forecast.daily_weather.count).to eq(5)
    expect(forecast.daily_weather.first).to be_a DailyWeather
    expect(forecast.hourly_weather).to be_an Array
    expect(forecast.hourly_weather.count).to eq(8)
    expect(forecast.hourly_weather.first).to be_a HourlyWeather
  end

  it 'can return an HourlyWeather' do
    dest_weather    = ForecastFacade.get_destination_weather(@lat, @lng)
    dest_weather_1  = dest_weather[0]

    expect(dest_weather).to be_a Array
    expect(dest_weather_1).to be_a HourlyWeather
    expect(dest_weather_1.conditions).to be_a String
    expect(dest_weather_1.icon).to be_a String
    expect(dest_weather_1.temperature).to be_a Float
    expect(dest_weather_1.time).to be_a String
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
    many_hourly_weather = ForecastFacade.get_many_hourly_weather(@weather)

    expect(many_hourly_weather).to be_an Array
    expect(many_hourly_weather.count).to eq(48)
    expect(many_hourly_weather.first).to be_an HourlyWeather
    expect(many_hourly_weather.first.conditions).to be_a String
    expect(many_hourly_weather.first.icon).to be_a String
    expect(many_hourly_weather.first.temperature).to be_a Float
  end

  it 'can get eight HourlyWeather objects' do
    hourly_weather = ForecastFacade.hourly_weather(@weather)
    first_hour     = hourly_weather[0]

    expect(hourly_weather).to be_an Array
    expect(hourly_weather.count).to eq(8)
    expect(first_hour).to be_an HourlyWeather
    expect(first_hour.conditions).to be_a String
    expect(first_hour.icon).to be_a String
    expect(first_hour.temperature).to be_a Float
  end

  it 'can get DailyWeather objects' do
    daily_weather = ForecastFacade.daily_weather(@weather)
    first_day     = daily_weather[0]

    expect(daily_weather).to be_an Array
    expect(daily_weather.count).to eq(5)
    expect(first_day).to be_an DailyWeather
    expect(first_day.conditions).to be_a String
    expect(first_day.icon).to be_a String
    expect(first_day.date).to be_a String
    expect(first_day.max_temp).to be_a Float
    expect(first_day.min_temp).to be_a Float
    expect(first_day.sunrise).to be_a Time
    expect(first_day.sunset).to be_a Time
  end
end
