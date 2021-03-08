require 'rails_helper'

RSpec.describe Forecast, :vcr do
  before(:each) do
    @location = 'mountain view, ca'
    @map      = MapService.coordinates_by_location(@location)
    @lat      = @map[:results][0][:locations][0][:latLng][:lat]
    @lng      = @map[:results][0][:locations][0][:latLng][:lng]
    @weather  = WeatherService.get_weather(@lat, @lng)
    @current_weather = CurrentWeather.new(@weather[:current])
    @daily_weather = @weather[:daily].map { |daily| DailyWeather.new(daily) }
    @hourly_weather = @weather[:hourly].map { |hourly| HourlyWeather.new(hourly) }
  end

  it 'exists and has attributes' do
    forecast = Forecast.new(@current_weather,@daily_weather,@hourly_weather)

    expect(forecast).to be_a Forecast
    expect(forecast.current_weather).to be_a CurrentWeather
    expect(forecast.daily_weather).to be_an Array
    expect(forecast.daily_weather[0]).to be_an DailyWeather
    expect(forecast.daily_weather[0].date).to be_a String
    expect(forecast.hourly_weather).to be_an Array
    expect(forecast.hourly_weather[0]).to be_a HourlyWeather
    expect(forecast.hourly_weather[0].conditions).to be_a String
    
    expect(forecast.current_weather).to_not be_an Array
    expect(forecast.daily_weather).to_not be_a Hash
    expect(forecast.hourly_weather).to_not be_a Hash
  end
end
