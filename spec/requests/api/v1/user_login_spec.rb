require 'rails_helper'

RSpec.describe 'User API Endpoint' do
  describe 'user login' do
    before(:each) do
      User.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('users')
      user = User.create!(email: 'example@email.com', password: 'password', password_confirmation: 'password')
      @headers = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
      @error   = "{\"error\":\"invalid credentials\"}"
    end

    describe 'happy paths' do
      it 'can login a user with correct credentials' do
        body = {
                'email': 'example@email.com',
                'password': 'password'
              }
  
        post '/api/v1/sessions', headers: @headers, params: JSON.generate(body)
  
        results         = JSON.parse(response.body, symbolize_names: true)[:data]
        results_attr    = results[:attributes]
        registered_user = User.find(results[:id].to_i)
  
        expect(response).to be_successful
        expect(results).to be_a Hash
  
        expect(response.status).to eq(200)
        expect(response.content_type).to eq('application/json')
        expect(results[:type]).to eq('users')
        expect(results_attr[:email]).to eq(body[:email])
  
        check_hash_structure(results, :id, String)
        check_hash_structure(results, :type, String)
        check_hash_structure(results, :attributes, Hash)
        check_hash_structure(results_attr, :email, String)
        check_hash_structure(results_attr, :api_key, String)
     
        expect(results_attr).to_not have_key(:password)
        expect(results_attr).to_not have_key(:password_digest)
        expect(results_attr).to_not have_key(:password_confirmation)
  
        expect(registered_user).to be_a User
        expect(registered_user.email).to be_a String
        expect(registered_user.email).to eq(body[:email])
        expect(registered_user.api_key).to be_a String
        expect(registered_user.api_key).to_not be_empty
      end
    end

    describe 'sad paths' do
      it 'returns an error if email is not provided' do
        body = {
                'email': '',
                'password': 'password'
              }
  
        post '/api/v1/sessions', headers: @headers, params: JSON.generate(body)
  
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to be_an String
        expect(response.body).to eq(@error)
      end
  
      it 'returns an error if passwords do not match' do
        body = {
                'email': 'example@email.com',
                'password': 'notarealpassword'
              }
  
        post '/api/v1/sessions', headers: @headers, params: JSON.generate(body)
  
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to be_an String
        expect(response.body).to eq(@error)
      end
  
      it 'returns an error if email do not match' do
        body = {
                'email': '@email.com',
                'password': 'notarealpassword'
              }
  
        post '/api/v1/sessions', headers: @headers, params: JSON.generate(body)
  
        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to be_an String
        expect(response.body).to eq(@error)
      end
    end
  end
end
