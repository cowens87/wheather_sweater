require 'rails_helper'

RSpec.describe 'RoadTrip Facade API', :vcr do
  before(:each) do 
    User.destroy_all
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
    @user = User.create(email: 'example@email.com', password: 'password')
    @road_trip_params = {
                          origin: 'mountain view, ca',
                          destination: 'bend, or',
                          api_key: @user.api_key
                        }
    @start_location   = @road_trip_params[:origin]
    @end_location     = @road_trip_params[:destination]
    @roadtrip         = RoadTripFacade.get_trip(@road_trip_params)
    @trip             = MapService.directions(@start_location, @end_location)
    @dest_weather     = RoadTripFacade.get_forecast_weather(@end_location)
    @weather_time     = RoadTripFacade.get_eta_weather_time(@trip, @dest_weather)
  end 

  it 'can create a Roadtrip Poro from two given locations' do
    expect(@roadtrip).to be_a Roadtrip
    expect(@trip).to be_a Hash
    expect(@trip).to have_key(:route)
    expect(@trip[:route]).to have_key(:realTime)
    expect(@dest_weather).to be_an Hash
    expect(@weather_time).to be_a HourlyWeather
    expect(@weather_time.conditions).to be_a String
    expect(@weather_time.icon).to be_a String
    expect(@weather_time.temperature).to be_a Float
    expect(@weather_time.time).to be_a String
    check_hash_structure(@dest_weather, :lat, Float)
    check_hash_structure(@dest_weather, :lon, Float)
    check_hash_structure(@dest_weather, :current, Hash)
    check_hash_structure(@dest_weather, :hourly, Array)
    check_hash_structure(@dest_weather, :daily, Array)
    check_hash_structure(@dest_weather, :lat, Float)
    check_hash_structure(@dest_weather, :lat, Float)
    check_hash_structure(@dest_weather, :lat, Float)
  end

  it 'cannot find a trip time, if the route is impossible' do
    road_trip_params = {
                        origin: 'Mountain View, CA',
                        destination: 'Nairobi, Kenya',
                        api_key: @user.api_key
                      }
    end_location     = road_trip_params[:destination]
    trip             = MapFacade.get_trip(@start_location, end_location)
    roadtrip         = RoadTripFacade.get_trip(road_trip_params)
    
    expect(roadtrip).to be_a Roadtrip
    expect(roadtrip.start_city).to be_a String
    expect(roadtrip.end_city).to be_a String
    expect(roadtrip.travel_time).to be_a String
    expect(roadtrip.weather_at_eta).to be_a String
    
    expect(trip[:info][:statuscode]).to eq(402)
    expect(roadtrip.start_city).to eq('Mountain View, CA')
    expect(roadtrip.end_city).to eq('Nairobi, Kenya')
    expect(roadtrip.travel_time).to eq('impossible route')
    expect(roadtrip.weather_at_eta).to eq('no data available')
  end

  describe 'edge cases' do
    it 'can round the time for the weather' do
      eta_weather_time         = Time.now + (@trip[:route][:realTime])
      find_destination_weather = RoadTripFacade.destination_weather(eta_weather_time, @dest_weather)
      rounded_weather          = RoadTripFacade.time_rounding(eta_weather_time)
    end
  end
end
