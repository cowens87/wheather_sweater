require 'rails_helper'

RSpec.describe 'Image Facade', :vcr do
  it 'can call an ImageService by a location' do
    location = 'mountain view, ca'

    photo = ImageFacade.location_photos(location)
    image = photo.image 
    expect(photo).to be_an Image
    expect(image).to be_a Hash

    expect(image).to_not have_key(:description)

    check_hash_structure(image, :location, String)
    check_hash_structure(image, :image_url, String)
    check_hash_structure(image[:credit], :source, String)
    check_hash_structure(image[:credit], :author, String)
    check_hash_structure(image[:credit], :logo, String)
  end
end
