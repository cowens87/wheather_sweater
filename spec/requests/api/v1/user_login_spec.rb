require 'rails_helper'

RSpec.describe 'User API' do
  describe 'user login' do
    it 'a registered user can login if creditials are correct' do
      User.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('users')
      user = User.create(email: 'example@email.com', password: 'password')

      body = {
        'email': 'example@email.com',
        'password': 'password'
      }

      headers = {
        'CONTENT_TYPE': 'application/json',
        'ACCEPT': 'application/json'
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')

      sessions_response = JSON.parse(response.body, symbolize_names: true)
      expect(sessions_response).to be_a Hash
      expect(sessions_response).to have_key(:data)
      expect(sessions_response[:data]).to have_key(:id)
      expect(sessions_response[:data][:id]).to be_a String
      expect(sessions_response[:data]).to have_key(:type)
      expect(sessions_response[:data][:type]).to be_a String
      expect(sessions_response[:data][:type]).to eq('users')
      expect(sessions_response[:data]).to have_key(:attributes)
      expect(sessions_response[:data][:attributes]).to have_key(:email)
      expect(sessions_response[:data][:attributes][:email]).to be_a String
      email = 'example@email.com'
      expect(sessions_response[:data][:attributes][:email]).to eq(email)
      expect(sessions_response[:data][:attributes]).to have_key(:api_key)
      expect(sessions_response[:data][:attributes][:api_key]).to be_a String
      expect(sessions_response[:data][:attributes]).to_not have_key(:password)
      expect(sessions_response[:data][:attributes]).to_not have_key(:password_digest)
      expect(sessions_response[:data][:attributes]).to_not have_key(:password_confirmation)

      logged_user = User.find(sessions_response[:data][:id].to_i)
      expect(logged_user).to be_a User
      expect(logged_user.email).to be_a String
      expect(logged_user.email).to eq(body[:email])
      expect(logged_user.api_key).to be_a String
      expect(logged_user.api_key).to_not be_empty
    end

    it 'can send error when login fails (empty email)' do
      User.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('users')
      user = User.create(email: 'example@email.com', password: 'password')

      body = {
        'email': '',
        'password': 'password'
      }

      headers = {
        'CONTENT_TYPE': 'application/json',
        'ACCEPT': 'application/json'
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to be_an String
      error = "{\"body\":[\"Invaild creditials. Please try again\"]}"
      expect(response.body).to eq(error)
    end

    it 'can send error with login fail (non-matching passwords)' do
      User.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('users')
      user = User.create(email: 'example@email.com', password: 'password')

      body = {
        'email': 'example@email.com',
        'password': 'notarealpassword'
      }

      headers = {
        'CONTENT_TYPE': 'application/json',
        'ACCEPT': 'application/json'
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to be_an String
      error = "{\"body\":[\"Invaild creditials. Please try again\"]}"
      expect(response.body).to eq(error)
    end

    it 'can send error with login fail (non-matching email)' do
      User.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!('users')
      user = User.create(email: 'example@email.com', password: 'password')

      body = {
        'email': '@email.com',
        'password': 'notarealpassword'
      }

      headers = {
        'CONTENT_TYPE': 'application/json',
        'ACCEPT': 'application/json'
      }

      post '/api/v1/sessions', headers: headers, params: JSON.generate(body)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to be_an String
      error = "{\"body\":[\"Invaild creditials. Please try again\"]}"
      expect(response.body).to eq(error)
    end
  end
end
