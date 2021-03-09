require 'rails_helper'

RSpec.describe 'Roadtrip API Endpoint', :vcr do
  before(:each) do 
    User.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
    @user      = User.create!(email: 'example@email.com', password: 'password', password_confirmation: 'password')
    @error_404 = "{\"body\":\"All fields are required. Please try again\"}"
    @error_401 = "{\"body\":\"API key is missing or invalid\"}"
    @headers   = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
  end
  
  describe 'happy paths' do
    it 'can create a successful road trip' do
      login_params     = {
                          'email': 'example@email.com',
                          'password': 'password'
                        }
      road_trip_params = {
                          origin: 'Mountain View, CA',
                          destination: 'Los Angeles, CA',
                          api_key: @user.api_key
                        }

      post '/api/v1/road_trip', headers: @headers, params: JSON.generate(road_trip_params)

      expect(response).to be_successful
      expect(response.status).to be(200)
      expect(response.content_type).to eq('application/json')

      road_trip            = JSON.parse(response.body, symbolize_names: true)
      road_trip_attributes = road_trip[:data][:attributes]
      
      expect(road_trip).to be_a Hash
      expect(road_trip[:data][:id]).to be_nil
      
      expect(road_trip[:data][:type]).to eq('roadtrip')

      check_hash_structure(road_trip, :data, Hash)
      check_hash_structure(road_trip[:data], :type, String)
      check_hash_structure(road_trip[:data], :attributes, Hash)
      check_hash_structure(road_trip_attributes, :start_city, String)
      check_hash_structure(road_trip_attributes, :end_city, String)
      check_hash_structure(road_trip_attributes, :travel_time, String)
      check_hash_structure(road_trip_attributes, :weather_at_eta, Hash)
      check_hash_structure(road_trip_attributes, :weather_at_eta, Hash)
      check_hash_structure(road_trip_attributes[:weather_at_eta], :temperature, Float)
      check_hash_structure(road_trip_attributes[:weather_at_eta], :conditions, String)
    end
  end

  describe 'sad paths' do
    it 'will not create a road trip if missing destination_city' do
      login_params     = {
                          'email': 'example@email.com',
                          'password': 'password'
                        }
      road_trip_params = {
                          origin: 'Mountain View, CA',
                          destination: '',
                          api_key: @user.api_key
                        }

      post '/api/v1/road_trip', headers: @headers, params: JSON.generate(road_trip_params)

      expect(response).to_not be_successful
      expect(response.status).to be(404)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to eq(@error_404)
    end

    it 'will not create a road trip if missing api_key' do
      login_params     = {
                          'email': 'example@email.com',
                          'password': 'password'
                        }
      road_trip_params = {
                          origin: 'Mountain View, CA',
                          destination: 'Los Angeles, CA',
                          api_key: ''
                        }

      post '/api/v1/road_trip', headers: @headers, params: JSON.generate(road_trip_params)

      expect(response).to_not be_successful
      expect(response.status).to be(401)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to eq(@error_401)
    end

    it 'will not create road trip if api keys do not match' do
      login_params     = {
                          'email': 'example@email.com',
                          'password': 'password'
                        }
      road_trip_params = {
                          origin: 'Mountain View, CA',
                          destination: 'Los Angeles, CA',
                          api_key: 'jgn983hy48thw9begh98h4539h4'
                        }

      expect(@user.email).to eq('example@email.com')
      expect(@user.password_digest).to be_a String
      expect(@user.api_key).to be_a String

      post '/api/v1/road_trip', headers: @headers, params: JSON.generate(road_trip_params)

      expect(@user.api_key).to_not eq(road_trip_params[:api_key])
      expect(response).to_not be_successful
      expect(response.status).to be(401)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to eq(@error_401)
    end
  end
end
