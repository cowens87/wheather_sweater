require 'rails_helper'

RSpec.describe Roadtrip, :vcr do
  it 'exists and has attributes' do
    road_trip_params = {
                        origin: 'Mountain View, CA',
                        destination: 'Bend, OR'
                      }
    roadtrip         = RoadTripFacade.get_trip(road_trip_params)

    expect(roadtrip).to be_a Roadtrip
    expect(roadtrip.start_city).to be_a String
    expect(roadtrip.end_city).to be_a String
    expect(roadtrip.travel_time).to be_a String
    expect(roadtrip.weather_at_eta).to be_a Hash

    expect(roadtrip.start_city).to eq('Mountain View, CA')
    expect(roadtrip.end_city).to eq('Bend, OR')
    expect(roadtrip.travel_time).to eq('08:21:14')

    check_hash_structure(roadtrip.weather_at_eta, :temperature, Float)
    check_hash_structure(roadtrip.weather_at_eta, :conditions, String)
  end

  it 'can create a short distance journey' do
    road_trip_params = {
                        origin: 'Mountain View, CA',
                        destination: 'Sacramento, CA'
                      }
    roadtrip         = RoadTripFacade.get_trip(road_trip_params)

    expect(roadtrip).to be_a Roadtrip
    expect(roadtrip.start_city).to be_a String
    expect(roadtrip.end_city).to be_a String
    expect(roadtrip.travel_time).to be_a String
    expect(roadtrip.weather_at_eta).to be_a Hash

    expect(roadtrip.start_city).to eq('Mountain View, CA')
    expect(roadtrip.end_city).to eq('Sacramento, CA')
    expect(roadtrip.travel_time).to eq('01:57:51')

    check_hash_structure(roadtrip.weather_at_eta, :temperature, Float)
    check_hash_structure(roadtrip.weather_at_eta, :conditions, String)
  end

  it 'can create a long distance trip' do
    road_trip_params = {
                        origin: 'Mountain View, CA',
                        destination: 'Vancouver, Canada'
                      }
    roadtrip         = RoadTripFacade.get_trip(road_trip_params)

    expect(roadtrip).to be_a Roadtrip
    expect(roadtrip.start_city).to be_a String
    expect(roadtrip.end_city).to be_a String
    expect(roadtrip.travel_time).to be_a String
    expect(roadtrip.weather_at_eta).to be_a Hash

    expect(roadtrip.start_city).to eq('Mountain View, CA')
    expect(roadtrip.end_city).to eq('Vancouver, Canada')
    expect(roadtrip.travel_time).to eq('15:38:53')

    check_hash_structure(roadtrip.weather_at_eta, :temperature, Float)
    check_hash_structure(roadtrip.weather_at_eta, :conditions, String)
  end

  it 'will not create a cross-oceanic trip' do
    road_trip_params = {
                        origin: 'Mountain View, CA',
                        destination: 'Nairobi, Kenya'
                      }
    roadtrip         = RoadTripFacade.get_trip(road_trip_params)

    expect(roadtrip).to be_a Roadtrip
    expect(roadtrip.start_city).to be_a String
    expect(roadtrip.end_city).to be_a String
    expect(roadtrip.travel_time).to be_a String
    expect(roadtrip.weather_at_eta).to be_a String

    expect(roadtrip.start_city).to eq('Mountain View, CA')
    expect(roadtrip.end_city).to eq('Nairobi, Kenya')
    expect(roadtrip.travel_time).to eq('impossible route')
    expect(roadtrip.weather_at_eta).to eq('no data available')
  end

  it 'can create a very long distance trip' do
    road_trip_params = {
                        origin: 'Mountain View, CA',
                        destination: 'Nova Scotia, Canada'
                      }
    roadtrip         = RoadTripFacade.get_trip(road_trip_params)

    expect(roadtrip).to be_a Roadtrip
    expect(roadtrip.start_city).to be_a String
    expect(roadtrip.end_city).to be_a String
    expect(roadtrip.travel_time).to be_a String
    expect(roadtrip.weather_at_eta).to be_a Hash

    expect(roadtrip.start_city).to eq('Mountain View, CA')
    expect(roadtrip.end_city).to eq('Nova Scotia, Canada')
    expect(roadtrip.travel_time).to eq('55:09:10')

    check_hash_structure(roadtrip.weather_at_eta, :temperature, Float)
    check_hash_structure(roadtrip.weather_at_eta, :conditions, String)
  end
end