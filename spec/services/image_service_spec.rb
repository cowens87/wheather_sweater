require 'rails_helper'

RSpec.describe ImageService, :vcr do
  it 'can successfully call unsplash database' do
    location = 'Mountain View, CA'
    json     = ImageService.location_photos(location)
    image    = json[:results][0]

    expect(json).to be_a Hash

    check_hash_structure(json, :results, Array)
    check_hash_structure(image, :urls, Hash)
    check_hash_structure(image, :user, Hash)
    check_hash_structure(image[:urls], :regular, String)
    check_hash_structure(image[:user], :name, String)
    check_hash_structure(image[:user], :links, Hash)
    check_hash_structure(image[:user][:links], :html, String)
  end
end
