require 'rails_helper'

RSpec.describe MapService, :vcr do
  it 'can make a successful faraday call to unsplash' do
    location = 'Denver, CO'
    map      = MapService.coordinates_by_location(location)
    map_loc  = map[:results][0][:locations][0]
    
    expect(map).to be_a Hash

    check_hash_structure(map, :results, Array)
    check_hash_structure(map[:results][0], :locations, Array)
    check_hash_structure(map_loc, :latLng, Hash)
    check_hash_structure(map_loc[:latLng], :lat, Float)
    check_hash_structure(map_loc[:latLng], :lng, Float)
    
    expect(map_loc[:latLng][:lat]).to eq(39.738453)
    expect(map_loc[:latLng][:lng]).to eq(-104.984853)
  end

  it 'will return an error if external call is not possible' do
    location = ''
    map      = MapService.coordinates_by_location(location)
    
    expect(map).to be_a Hash
    expect(map).to have_key(:info)
    expect(map[:info]).to be_a Hash

    check_hash_structure(map[:info], :statuscode, Integer)
    check_hash_structure(map[:info], :messages, Array)
    
    expect(map[:info][:statuscode]).to eq(400)
    expect(map[:info][:messages][0]).to eq('Illegal argument from request: Insufficient info for location')
  end
end