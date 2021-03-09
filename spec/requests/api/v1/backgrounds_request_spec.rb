require 'rails_helper'

RSpec.describe 'Image API Endpoint', :vcr do
  describe 'it can return a background image based on location' do
    describe 'happy paths' do
      it 'can find an Unsplash image' do
        location_params = {
                          location: 'denver, co'
                        }
        headers         = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
  
        get '/api/v1/backgrounds', headers: headers, params: location_params
  
        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(response.content_type).to eq('application/json')
  
        image            = JSON.parse(response.body, symbolize_names: true)[:data]
        image_attributes = image[:attributes][:image]
  
        expect(image).to be_a Hash
        expect(image).to have_key(:id)
        expect(image[:id]).to be_nil
        expect(image).to have_key(:type)
        expect(image[:type]).to eq('image')
        expect(image).to have_key(:attributes)
        expect(image[:attributes]).to be_a Hash
        expect(image[:attributes]).to have_key(:image)
  
        check_hash_structure(image_attributes, :location, String)
        check_hash_structure(image_attributes, :image_url, String)
        check_hash_structure(image_attributes[:credit], :author, String)
        check_hash_structure(image_attributes[:credit], :logo, String)
        check_hash_structure(image_attributes[:credit], :source, String)
      end
    end

    describe 'sad paths' do
      it 'returns an error for an Image without a location' do
        location_params = { location: '' }
        headers         = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
        error           =  "{\"body\":\"Unable to find image without location\"}"
    
        get '/api/v1/backgrounds', headers: headers, params: location_params
  
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq(error)
      end
    end
  end
end