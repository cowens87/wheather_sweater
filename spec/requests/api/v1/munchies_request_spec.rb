
require 'rails_helper'

RSpec.describe 'Yelp API Endpoint', :vcr do
  describe 'happy paths' do
    it 'can find food recommendation and weather for destination' do
      munchies_params = {
                          origin: 'Denver, CO',
                          destination: 'Pueblo, CO',
                          food: 'hamburger'
                        }
      headers         = {
                          'CONTENT_TYPE': 'application/json',
                          'Authorization': "Bearer #{ENV['YELP_API_KEY']}"
                        }
  
      get '/api/v1/munchies', headers: headers, params: munchies_params
  
      munchie       = JSON.parse(response.body, symbolize_names: true)[:data]
      munchie_attr  = munchie[:attributes]
      munchie_frcst = munchie[:attributes][:forecast]
      munchie_rest  = munchie[:attributes][:restaurant]
  
      expect(munchie[:id]).to be_nil
      expect(munchie[:type]).to eq('munchie')
      check_hash_structure(munchie, :id, String)
      check_hash_structure(munchie, :type, String)
      check_hash_structure(munchie_attr, :destination_city, String)
      check_hash_structure(munchie_attr, :travel_time, String)
      check_hash_structure(munchie_attr, :forecast, Hash)
      check_hash_structure(munchie_attr, :restaurant, Hash)
      check_hash_structure(munchie_frcst, :summary, String)
      check_hash_structure(munchie_frcst, :temperature, Integer)
      check_hash_structure(munchie_rest, :name, String)
      check_hash_structure(munchie_rest, :address, String)
    end
  end
end