class ImageService
  class << self
    def location_photos(location)
      response = connection.get('/search/photos') do |req|
        req.params[:client_id]      = ENV['UNSPLASH_API_KEY']
        req.params[:query]          = location
        req.params[:content_filter] = 'high'
        req.params[:orientation]    = 'landscape'
      end
      parse_data(response)
    end

    private

    def connection
      Faraday.new(url: 'https://api.unsplash.com/')
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
