require 'rails_helper'

RSpec.describe 'User API', :vcr do
  describe 'user registration' do
    before(:each) do
      @headers   = { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' }
    end

    describe 'happy paths' do
      it 'can register a new user' do
        new_user = {
                    'email': 'example@email.com',
                    'password': 'password',
                    'password_confirmation': 'password'
                  }
        
        post '/api/v1/users', headers: @headers, params: JSON.generate(new_user)
        
        user_response = JSON.parse(response.body, symbolize_names: true)
        user          = User.last
        email         = 'example@email.com'

        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(response.content_type).to eq('application/json')
        
        expect(user_response).to be_a Hash
        expect(user).to be_a User
        expect(user.api_key).to be_a String
        
        check_hash_structure(user_response, :data, Hash)
        check_hash_structure(user_response[:data], :type, String)
        check_hash_structure(user_response[:data], :attributes, Hash)
        check_hash_structure(user_response[:data], :id, String)
        check_hash_structure(user_response[:data][:attributes], :email, String)
        check_hash_structure(user_response[:data][:attributes], :api_key, String)

        expect(user_response[:data][:type]).to eq('users')
        expect(user_response[:data][:attributes][:email]).to eq(email)
        expect(user.email).to eq(new_user[:email])
        expect(user.api_key).to eq(user_response[:data][:attributes][:api_key])
      end
    end

    describe 'sad paths' do
      it 'will not create a user if all info is not provided' do
        new_user = {
                    'email': '',
                    'password': 'password',
                    'password_confirmation': 'password'
                  }

        post '/api/v1/users', headers: @headers, params: JSON.generate(new_user)

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq("{\"body\":[\"Email (can't be blank); \"]}")

        expect(response.body).to be_a String
      end

      it 'will not create a user if passwords do not match' do
        new_user = {
                    'email': 'example@email.com',
                    'password': 'password',
                    'password_confirmation': 'differentpassword'
                  }

        post '/api/v1/users', headers: @headers, params: JSON.generate(new_user)

        expected = "{\"body\":[\"Password_confirmation (doesn't match Password); \"]}"
        
        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to be_a String
        expect(response.body).to eq(expected)
      end

      it 'will not create a new user with an email that is already active' do
        new_user = {
                    'email': 'example@email.com',
                    'password': 'password',
                    'password_confirmation': 'password'
                  }

        post '/api/v1/users', headers: @headers, params: JSON.generate(new_user)

        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(response.content_type).to eq('application/json')

        new_user2 = {
                    'email': 'example@email.com',
                    'password': 'password',
                    'password_confirmation': 'password'
                  }

        post '/api/v1/users', headers: @headers, params: JSON.generate(new_user2)
        
        error = "{\"body\":[\"Email (has already been taken); \"]}"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to be_a String
        expect(response.body).to eq(error)
      end
    end
  end
end
