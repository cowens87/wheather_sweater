class ImageService < ApplicationService
  class << self
    def location_photos(location)
      response = connection(unsplash).get('/search/photos') do |req|
        req.params[:client_id]      = ENV['UNSPLASH_API_KEY']
        req.params[:query]          = location
        req.params[:content_filter] = 'high'
        req.params[:orientation]    = 'landscape'
      end
      parse_data(response)
    end
  end
end
