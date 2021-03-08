require 'rails_helper'

RSpec.describe Image, :vcr do
  it 'exists and has attributes' do
    location = 'Mountain, View, CA'
    images   = ImageService.location_photos(location)
    image    = Image.new(images[:results][0], location)
    logo     = 'https://unsplash.com/@bubo'

    expect(image).to be_an Image
    expect(image.image).to be_a Hash

    check_hash_structure(image.image, :image_url, String)
    check_hash_structure(image.image, :location, String)
    check_hash_structure(image.image[:credit], :source, String)
    check_hash_structure(image.image[:credit], :author, String)
    check_hash_structure(image.image[:credit], :logo, String)

    expect(image.image[:location]).to eq('Mountain, View, CA')
    expect(image.image[:credit][:source]).to eq('https://unsplash.com/')
    expect(image.image[:credit][:author]).to eq('Lubo Minar')
    expect(image.image[:credit][:logo]).to eq(logo)
  end
end
