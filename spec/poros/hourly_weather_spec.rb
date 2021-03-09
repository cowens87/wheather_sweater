require 'rails_helper'

RSpec.describe HourlyWeather, :vcr do
  before(:each) do
    @location = 'mountain view, ca'
    @map      = MapService.coordinates_by_location(@location)
    @lat      = @map[:results][0][:locations][0][:latLng][:lat]
    @lng      = @map[:results][0][:locations][0][:latLng][:lng]
    @weather  = WeatherService.get_weather(@lat, @lng)
    @multi_hour_weather = @weather[:hourly].map { |hourly| HourlyWeather.new(hourly) }
  end

  it 'exists and has attributes' do
    weather_of_the_hour = @multi_hour_weather[0]

    expect(@multi_hour_weather).to be_an Array
    expect(weather_of_the_hour).to be_a HourlyWeather

    expect(weather_of_the_hour.temperature).to eq(55.35)
    expect(weather_of_the_hour.time).to eq('11:00:00')
    expect(weather_of_the_hour.conditions).to eq('broken clouds')
    expect(weather_of_the_hour.icon).to eq('04d')
    
    expect(weather_of_the_hour.time).to_not eq(1615071600) 
    expect(weather_of_the_hour.temperature).to_not eq(293.58)
  end
end
  
