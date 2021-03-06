require 'rails_helper'

RSpec.describe 'Image Facade', :vcr do
  it 'can call an ImageService by a location' do
    location = 'mountain view, ca'

    photo = ImageFacade.location_photos(location)
    image = photo.image 
    credit = photo.credit

    expect(photo).to be_an Image
    expect(image).to be_a Hash
    expect(credit).to be_a Hash

    expect(image).to_not have_key(:description)

    check_hash_structure(image, :image_url, String)
    check_hash_structure(image, :link, String)
    check_hash_structure(credit, :source, String)
    check_hash_structure(credit, :artist, String)
    check_hash_structure(credit, :artist_link, String)
  end
end
