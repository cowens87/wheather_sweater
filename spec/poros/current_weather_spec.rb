require 'rails_helper'

RSpec.describe CurrentWeather, :vcr do
  before(:each) do
    @location = 'mountain view, ca'
    @map      = MapService.coordinates_by_location(@location)
    @lat      = @map[:results][0][:locations][0][:latLng][:lat]
    @lng      = @map[:results][0][:locations][0][:latLng][:lng]
    @weather  = WeatherService.get_weather(@lat, @lng)
    @current_weather = CurrentWeather.new(@weather[:current])
  end

  it 'has attributes and exists' do
    expect(@current_weather).to be_a CurrentWeather
    expect(@current_weather.datetime).to be_a Time
    expect(@current_weather.sunrise).to be_a Time
    expect(@current_weather.sunset).to be_a Time
    expect(@current_weather.temperature).to be_a Float
    expect(@current_weather.feels_like).to be_a Float
    expect(@current_weather.humidity).to be_a Numeric
    expect(@current_weather.uvi).to be_a Numeric
    expect(@current_weather.conditions).to be_a String
    expect(@current_weather.visibility).to be_a Numeric
    expect(@current_weather.icon).to be_a String

    expect(@current_weather.datetime).to eq('2021-03-07 12:31:38.000000000 -0800')
    expect(@current_weather.sunrise).to eq('2021-03-07 06:30:43.000000000 -0800')
    expect(@current_weather.sunset).to eq('2021-03-07 18:08:03.000000000 -0800')
    expect(@current_weather.temperature).to eq(59.18)
    expect(@current_weather.feels_like).to eq(49.98)
    expect(@current_weather.humidity).to eq(44)
    expect(@current_weather.uvi).to eq(4.56)
    expect(@current_weather.conditions).to eq('clear sky')
    expect(@current_weather.visibility).to eq(10000)
    expect(@current_weather.icon).to eq('01d')

    expect(@current_weather.datetime).to_not eq(1615073230)
    expect(@current_weather.sunrise).to_not eq(1615079301)
    expect(@current_weather.sunset).to_not eq(1615121644)
    expect(@current_weather.temperature).to_not eq(293.58)
    expect(@current_weather.feels_like).to_not eq(289.19)
  end
end