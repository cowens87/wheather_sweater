require 'rails_helper'

RSpec.describe Map, :vcr do
  it 'exists and has attributes' do
    location    = 'mountain view, ca'
    coordinates = MapService.coordinates_by_location(location)
    map         = Map.new(coordinates)

    expect(map).to be_a Map
    expect(map.messages).to be_an Array
    expect(map.messages).to be_empty
    expect(map.latitude).to be_a Float
    expect(map.longitude).to be_a Float
    expect(map.status_code).to be_an Integer

    expect(map.id).to eq(nil)
    expect(map.status_code).to eq(0)
    expect(map.latitude).to eq(37.39008)
    expect(map.longitude).to eq(-122.08139)

    expect(map.latitude).to_not eq(39)
    expect(map.longitude).to_not eq(-105)
  end

  it 'returns a 400 if no location provided' do
    location    = ''
    coordinates = MapService.coordinates_by_location(location)
    map         = Map.new(coordinates)
    expected    = 'Illegal argument from request: Insufficient info for location'

    expect(map).to be_a Map
    expect(map.status_code).to be_an Integer
    expect(map.messages).to be_an Array
    expect(map.messages[0]).to be_a String
    
    expect(map.latitude).to be_nil
    expect(map.longitude).to be_nil
    
    expect(map.id).to eq(nil)
    expect(map.status_code).to eq(400)
    expect(map.messages[0]).to eq(expected)
  end
end
