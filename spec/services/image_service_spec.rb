require 'rails_helper'

RSpec.describe ImageService, :vcr do
  it 'can make a successful faraday call to unsplash' do
    location = 'denver, co'
    json = ImageService.get_images(location)

    expect(json).to be_a Hash
    expect(json[:results]).to be_an Array
    image = json[:results].first
    expect(image).to have_key(:urls)
    expect(image[:urls]).to be_a Hash
    expect(image[:urls]).to have_key(:regular)
    expect(image[:urls][:regular]).to be_a String
    expect(image).to have_key(:user)
    expect(image[:user]).to be_a Hash
    expect(image[:user]).to have_key(:name)
    expect(image[:user][:name]).to be_a String
    expect(image[:user]).to have_key(:links)
    expect(image[:user][:links]).to be_a Hash
    expect(image[:user][:links]).to have_key(:html)
    expect(image[:user][:links][:html]).to be_a String
  end
end
