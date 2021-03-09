require 'rails_helper'

RSpec.describe WeatherService,  type: :model do
  it 'can successfully connect to openweathermap',:vcr do
    location = 'mountain view, ca'
    map      = MapService.coordinates_by_location(location)
    lat      = map[:results][0][:locations][0][:latLng][:lat]
    lng      = map[:results][0][:locations][0][:latLng][:lng]
    forecast = WeatherService.get_weather(lat, lng)
    
    expect(forecast).to be_a Hash
    expect(forecast).to have_key(:lat)
    expect(forecast).to have_key(:lon)
    expect(forecast[:lat]).to eq(lat.round(4))
    expect(forecast[:lon]).to eq(lng.round(4))
    
    ## Current Weather ## 
    current_forecast = forecast[:current]

    expect(forecast).to have_key(:current)
    check_hash_structure(forecast, :current, Hash)
    
    expect(current_forecast).to have_key(:dt)
    expect(current_forecast).to have_key(:sunrise)
    expect(current_forecast).to have_key(:sunset)
    expect(current_forecast).to have_key(:temp)
    expect(current_forecast).to have_key(:feels_like)
    expect(current_forecast).to have_key(:humidity)
    expect(current_forecast).to have_key(:uvi)
    expect(current_forecast).to have_key(:visibility)
    expect(current_forecast).to have_key(:weather)
    expect(current_forecast[:weather][0]).to have_key(:description) 
    expect(current_forecast[:weather][0]).to have_key(:icon)
    
    # Formatted DateTime Tests
    expect(Time.at(current_forecast[:dt])).to be_a Time
    expect(Time.at(current_forecast[:sunrise])).to be_a Time
    expect(Time.at(current_forecast[:sunset])).to be_a Time
    
    check_hash_structure(current_forecast, :dt, Integer)
    check_hash_structure(current_forecast, :sunrise, Integer)
    check_hash_structure(current_forecast, :sunset, Integer)
    check_hash_structure(current_forecast, :temp, Numeric)
    check_hash_structure(current_forecast, :feels_like, Numeric)
    check_hash_structure(current_forecast, :humidity, Numeric)
    check_hash_structure(current_forecast, :uvi, Numeric)
    check_hash_structure(current_forecast, :visibility, Numeric)
    check_hash_structure(current_forecast, :weather, Array)
    check_hash_structure(current_forecast[:weather][0], :description, String)
    check_hash_structure(current_forecast[:weather][0], :icon, String)
  
    expect(current_forecast[:temp]).to eq(55.47)
    expect(current_forecast[:feels_like]).to eq(46.98)
    expect(current_forecast[:visibility]).to eq(10000)
    expect(current_forecast[:weather][0][:description]).to eq('broken clouds')
    expect(current_forecast[:weather][0][:icon]).to eq('04d')
    expect(Time.at(current_forecast[:sunset])).to eq('2021-03-09 18:09:56.000000000 -0800')
    expect(Time.at(current_forecast[:sunset])).to_not eq(1610841641)

    ## Daily Weather ##
    daily_forecast = forecast[:daily][0]

    check_hash_structure(forecast, :daily, Array)
    check_hash_structure(daily_forecast,:dt, Integer)
    check_hash_structure(daily_forecast, :sunrise, Integer)
    check_hash_structure(daily_forecast, :sunset, Integer)
    check_hash_structure(daily_forecast,:temp, Hash)
    check_hash_structure(daily_forecast, :weather, Array)
    check_hash_structure(daily_forecast[:temp], :max, Float)
    check_hash_structure(daily_forecast[:temp], :min, Float)
    check_hash_structure(daily_forecast[:weather][0], :description, String)
    check_hash_structure(daily_forecast[:weather][0], :icon, String)

    expect(forecast[:daily].length).to eq(8)
    expect(daily_forecast[:weather][0][:description]).to eq('moderate rain')
    expect(daily_forecast[:weather][0][:icon]).to eq('10d')
    expect(daily_forecast[:temp][:max]).to eq(57.11)
    expect(daily_forecast[:temp][:max]).to_not eq(324.53)

    # Hourly Weather ##
    hourly_forecast = forecast[:hourly][0]
    
    expect(Time.at(forecast[:hourly][0][:dt]).strftime('%Y-%m-%d')).to be_a String
    
    expect(hourly_forecast[:temp]).to eq(55.47)
    
    check_hash_structure(forecast, :hourly, Array)
    check_hash_structure(hourly_forecast, :dt, Integer)
    check_hash_structure(hourly_forecast, :temp, Float)
    check_hash_structure(hourly_forecast, :weather, Array)
    check_hash_structure(hourly_forecast[:weather][0], :description, String)
    check_hash_structure(hourly_forecast[:weather][0], :icon, String)
  end
end
