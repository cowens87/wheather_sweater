require 'rails_helper'

RSpec.describe MapFacade, :vcr do
  it 'can find coordinates of a location' do
    location    = 'mountain view, ca'
    map         = MapFacade.get_coordinates(location)
    status_code = map.status_code
    messages    = map.messages
    lat         = map.latitude
    lon         = map.longitude

    expect(map).to be_a Map
    expect(map.id).to be_nil
    expect(status_code).to be_an Integer
    expect(status_code).to eq(0)
    expect(messages).to be_an Array
    expect(messages).to be_empty
    expect(lat).to be_an Float
    expect(lat).to eq(37.39008)
    expect(lon).to be_an Float
    expect(lon).to eq(-122.08139)
  end

  it 'can make a trip from start location to end location' do
    start_location = 'mountain view, ca'
    end_location   = 'bend, or'
    trip_duration  = MapFacade.get_trip(start_location, end_location)
    route          = trip_duration[:route]
    bound_box      = route [:boundingBox]

    expect(trip_duration).to be_a Hash
    expect(bound_box).to be_a Hash
    
    check_hash_structure(trip_duration, :route, Hash)
    check_hash_structure(route, :boundingBox, Hash)
    check_hash_structure(route, :realTime, Integer)
    check_hash_structure(route, :formattedTime, String)
    check_hash_structure(route, :routeError, Hash)
    check_hash_structure(bound_box, :lr, Hash)
    check_hash_structure(bound_box, :ul, Hash)
    check_hash_structure(bound_box[:lr], :lng, Float)
    check_hash_structure(bound_box[:lr], :lat, Float)
    check_hash_structure(bound_box[:ul], :lng, Float)
    check_hash_structure(bound_box[:ul], :lat, Float)

    expect(route[:realTime]).to eq(10000000)
    expect(route[:formattedTime]).to eq("08:21:14")
    expect(bound_box[:lr][:lng]).to eq(-121.306137)
    expect(bound_box[:lr][:lat]).to eq(37.390015)
    expect(bound_box[:ul][:lng]).to eq(-122.387421)
    expect(bound_box[:ul][:lat]).to eq(44.058086)
  end
end
