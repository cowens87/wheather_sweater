require 'rails_helper'

RSpec.describe DailyWeather, :vcr do
  before(:each) do
    @location = 'mountain view, ca'
    @map      = MapService.coordinates_by_location(@location)
    @lat      = @map[:results][0][:locations][0][:latLng][:lat]
    @lng      = @map[:results][0][:locations][0][:latLng][:lng]
    @weather  = WeatherService.get_weather(@lat, @lng)
    @multi_day_weather = @weather[:daily].map { |daily| DailyWeather.new(daily) }
  end

  it 'has attributes and exists' do
    day = @multi_day_weather[0]

    expect(day).to be_a DailyWeather
    expect(day.date).to eq('2021-03-09')
    expect(day.sunrise).to eq('2021-03-09 06:27:48.000000000 -0800')
    expect(day.sunset).to eq('2021-03-09 18:09:56.000000000 -0800')
    expect(day.max_temp).to eq(57.09)
    expect(day.min_temp).to eq(45.18)
    expect(day.conditions).to eq('moderate rain')
    expect(day.icon).to eq('10d')

    expect(day.date).to_not eq(1615073230)
    expect(day.sunrise).to_not eq(1615079301)
    expect(day.sunset).to_not eq(1615121644)
    expect(day.max_temp).to_not eq(310.93)
    expect(day.min_temp).to_not eq(292.68)
  end
end
