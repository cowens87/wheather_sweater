class Image
  attr_reader :image

  def initialize(image_data, location)
    @image  = {
              location: location,
              image_url: image_data[:urls][:regular],
              credit: {
                        source: 'https://unsplash.com/',
                        author: image_data[:user][:name],
                        logo: image_data[:user][:links][:html]
                      }
            }
  end
end