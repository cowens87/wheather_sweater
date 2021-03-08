class ImageFacade
  def self.location_photos(location)
    photos = ImageService.location_photos(location)
    Image.new(photos[:results][0], location)
  end
end