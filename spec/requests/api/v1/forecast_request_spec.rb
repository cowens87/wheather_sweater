require 'rails_helper'

RSpec.describe 'Forecast API Endpoint', :vcr do
  describe 'happy paths' do
    it 'can request forecast by location ' do
      forecast_params = { location: 'denver, co' }
      headers         = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }

      get '/api/v1/forecast', headers: headers, params: forecast_params

      forecast        = JSON.parse(response.body, symbolize_names: true)[:data]
      current_weather = forecast[:attributes][:current_weather]
      daily_weather   = forecast[:attributes][:daily_weather][0]
      hourly_weather  = forecast[:attributes][:hourly_weather][0]

      expect(response).to be_successful
      expect(response.content_type).to eq('application/json')
      expect(response.status).to eq(200)
      expect(response.body).to be_a String
      expect(forecast).to be_a Hash
      expect(current_weather).to be_a Hash
      expect(daily_weather).to be_a Hash
      expect(hourly_weather).to be_a Hash
      expect(forecast[:id]).to be_nil
      expect(forecast[:type]).to eq('forecast')
      
      check_hash_structure(forecast, :attributes, Hash)
      check_hash_structure(current_weather, :datetime, String)
      check_hash_structure(current_weather, :sunrise, String)
      check_hash_structure(current_weather, :sunset, String)
      check_hash_structure(current_weather, :temperature, Float)
      check_hash_structure(current_weather, :humidity, Numeric)
      check_hash_structure(current_weather, :feels_like, Numeric)
      check_hash_structure(current_weather, :uvi, Numeric)
      check_hash_structure(current_weather, :visibility, Numeric)
      check_hash_structure(current_weather, :conditions, String)
      check_hash_structure(current_weather, :icon, String)
      check_hash_structure(daily_weather, :date, String)
      check_hash_structure(daily_weather, :sunrise, String)
      check_hash_structure(daily_weather, :sunset, String)
      check_hash_structure(daily_weather, :max_temp, Float)
      check_hash_structure(daily_weather, :min_temp, Float)
      check_hash_structure(daily_weather, :conditions, String)
      check_hash_structure(daily_weather, :icon, String)
      check_hash_structure(daily_weather, :date, String)
      check_hash_structure(daily_weather, :date, String)
      check_hash_structure(hourly_weather, :time, String)
      check_hash_structure(hourly_weather, :temperature, Float)
      check_hash_structure(hourly_weather, :conditions, String)
      check_hash_structure(hourly_weather, :icon, String)
    
      expect(current_weather).to_not have_key(:clouds)
      expect(current_weather).to_not have_key(:wind_speed)
      expect(current_weather).to_not have_key(:wind_deg)
      expect(current_weather).to_not have_key(:wind_speed)
      expect(daily_weather).to_not have_key(:wind_deg)
      expect(daily_weather).to_not have_key(:dew_point)
      expect(daily_weather).to_not have_key(:dew_point)
      expect(daily_weather).to_not have_key(:pop)
      expect(daily_weather).to_not have_key(:uvi)
      expect(hourly_weather).to_not have_key(:dew_point)
      expect(hourly_weather).to_not have_key(:visibility)
      expect(hourly_weather).to_not have_key(:feels_like)
      expect(hourly_weather).to_not have_key(:clouds)
      expect(hourly_weather).to_not have_key(:wind_deg)
      expect(hourly_weather).to_not have_key(:dew_point)

      expect(forecast[:attributes][:daily_weather].count).to eq(5)
      expect(forecast[:attributes][:hourly_weather].count).to eq(8)
    end
  end

  describe 'sad paths' do
    it 'returns an error if no location is provided' do
      forecast_params = { location: '' }
      headers         = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }

      get '/api/v1/forecast', headers: headers, params: forecast_params
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.body).to be_an String
    end
  end
end

