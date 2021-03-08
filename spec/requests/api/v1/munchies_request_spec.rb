
require 'rails_helper'

RSpec.describe 'Yelp API Endpoint', :vcr do
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

    munchie = JSON.parse(response.body, symbolize_names: true)[:data]
require 'pry'; binding.pry

end