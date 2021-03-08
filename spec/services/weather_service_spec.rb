require 'rails_helper'
require 'rails_helper'

RSpec.describe WeatherService,  type: :model do
  it 'can make a successful faraday call to openweathermap',:vcr do
    location = 'mountain view, ca'
    map = MapService.coordinates_by_location(location)
    lat = map[:results][0][:locations][0][:latLng][:lat]
    lng = map[:results][0][:locations][0][:latLng][:lng]
    
    forecast                 = WeatherService.forecast(lat, lng)
    current_forecast         = forecast[:current]
    current_forecast_weather = current_forecast[:weather][0]

    expect(forecast).to be_a Hash
    expect(forecast).to have_key(:lat)
    expect(forecast).to have_key(:lon)
    expect(forecast[:lat]).to eq(lat.round(4))
    expect(forecast[:lon]).to eq(lng.round(4))

    ## CURRENT WEATHER ## 
    expect(forecast).to have_key(:current)
    check_hash_structure(forecast, :current, Hash)
    
    # Keys Current Weather Hash Should Have
    expect(current_forecast).to have_key(:dt)
    expect(current_forecast).to have_key(:sunrise)
    expect(current_forecast).to have_key(:sunset)
    expect(current_forecast).to have_key(:temp)
    expect(current_forecast).to have_key(:feels_like)
    expect(current_forecast).to have_key(:humidity)
    expect(current_forecast).to have_key(:uvi)
    expect(current_forecast).to have_key(:visibility)
    expect(current_forecast).to have_key(:weather)
    expect(current_forecast_weather).to have_key(:description) # conditions, the first ‘description’ field from the weather data
    expect(current_forecast_weather).to have_key(:icon)
    
    # Formatted DateTime Tests
    expect(Time.at(current_forecast[:dt])).to be_a Time
    expect(Time.at(current_forecast[:sunrise])).to be_a Time
    expect(Time.at(current_forecast[:sunset])).to be_a Time
    
    # Current Weather Key Data Types
    check_hash_structure(current_forecast, :dt, Integer)
    check_hash_structure(current_forecast, :sunrise, Integer)
    check_hash_structure(current_forecast, :sunset, Integer)
    check_hash_structure(current_forecast, :temp, Numeric)
    check_hash_structure(current_forecast, :feels_like, Numeric)
    check_hash_structure(current_forecast, :humidity, Numeric)
    check_hash_structure(current_forecast, :uvi, Numeric)
    check_hash_structure(current_forecast, :visibility, Numeric)
    check_hash_structure(current_forecast, :weather, Array)
    check_hash_structure(current_forecast_weather, :description, String)
    check_hash_structure(current_forecast_weather, :icon, String)
    
    # Current Weather Unwanted Keys
    expect(current_forecast).to_not have_key(:wind_speed)
    expect(current_forecast).to_not have_key(:wind_deg)

    # Acurately Getting Back Results?
    expect(current_forecast[:temp]).to eq(63.97)
    expect(current_forecast[:feels_like]).to eq(55.62)
    expect(current_forecast[:visibility]).to eq(10000)

    expected = '2021-03-05 18:06:09 -0800'

    expect(Time.at(current_forecast[:sunset])).to eq(expected)
    expect(Time.at(current_forecast[:sunset])).to_not eq(1610841641)
    expect(current_forecast_weather[:description]).to eq('clear sky')
    expect(current_forecast_weather[:icon]).to eq('01d')

    # expect(forecast).to have_key(:daily)
    # expect(forecast[:daily]).to be_a Array
    # expect(forecast[:daily].length).to eq(8)
    # expect(forecast[:daily].first).to have_key(:dt)
    # expect(forecast[:daily].first[:dt]).to be_a Integer
    # expect(Time.at(forecast[:daily].first[:dt])).to be_a Time
    # expect(forecast[:daily].first).to have_key(:sunrise)
    # expect(forecast[:daily].first[:sunrise]).to be_a Integer
    # expect(Time.at(forecast[:daily].first[:sunrise])).to be_a Time
    # expect(forecast[:daily].first).to have_key(:sunset)
    # expect(forecast[:daily].first[:sunset]).to be_a Integer
    # expect(Time.at(forecast[:daily].first[:sunset])).to be_a Time
    # expect(forecast[:daily].first).to have_key(:temp)
    # expect(forecast[:daily].first[:temp]).to be_a Hash
    # expect(forecast[:daily].first[:temp]).to have_key(:max)
    # expect(forecast[:daily].first[:temp][:max]).to be_a Float
    # expect(forecast[:daily].first[:temp]).to have_key(:min)
    # expect(forecast[:daily].first[:temp][:min]).to be_a Float
    # expect(forecast[:daily].first).to have_key(:weather)
    # expect(forecast[:daily].first[:weather]).to be_an Array
    # expect(forecast[:daily].first[:weather].first).to have_key(:description)
    # expect(forecast[:daily].first[:weather].first[:description]).to be_a String
    # expect(forecast[:daily].first[:weather].first).to have_key(:icon)
    # expect(forecast[:daily].first[:weather].first[:icon]).to be_a String
    # description = 'clear sky'
    # expect(forecast[:daily].first[:weather].first[:description]).to eq(description)
    # expect(forecast[:daily].first[:weather].first[:icon]).to eq('01d')
    # expect(forecast[:daily].first[:temp][:max]).to eq(47.77)
    # expect(forecast[:daily].first[:temp][:max]).to_not eq(324.53)

    # expect(forecast).to have_key(:hourly)
    # expect(forecast[:hourly]).to be_an Array
    # expect(forecast[:hourly].first).to have_key(:dt)
    # expect(forecast[:hourly].first[:dt]).to be_a Integer
    # expect(Time.at(forecast[:hourly].first[:dt]).strftime('%Y-%m-%d')).to be_a String
    # expect(forecast[:hourly].first).to have_key(:temp)
    # expect(forecast[:hourly].first[:temp]).to be_a Float
    # expect(forecast[:hourly].first[:temp]).to eq(47.77)
    # expect(forecast[:hourly].first).to have_key(:wind_speed)
    # expect(forecast[:hourly].first[:wind_speed]).to be_a Float
    # expect(forecast[:hourly].first).to have_key(:wind_deg)
    # expect(forecast[:hourly].first[:wind_deg]).to be_an Integer
    # expect(forecast[:hourly].first[:wind_deg]).to eq(323)
    # expect(forecast[:hourly].first).to have_key(:weather)
    # expect(forecast[:hourly].first[:weather]).to be_an Array
    # expect(forecast[:hourly].first[:weather].first).to have_key(:description)
    # expect(forecast[:hourly].first[:weather].first[:description]).to be_a String
    # expect(forecast[:hourly].first[:weather].first).to have_key(:icon)
    # expect(forecast[:hourly].first[:weather].first[:icon]).to be_a String
  end
end
