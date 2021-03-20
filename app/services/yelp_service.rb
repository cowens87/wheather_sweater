class YelpService
  def self.businesses(location, arrival_time, food_category)
    response = connection.get('/v3/businesses/search?') do |req|
      req.headers['Authorization'] = "Bearer #{ENV.fetch('YELP_API_KEY')}"
      req.params[:term]            = food_category
      req.params[:location]        = location
      req.params[:open_at]         = arrival_time
    end
    parse_data(response)
  end

  private

  def self.connection
    Faraday.new(url: 'https://api.yelp.com/')
  end

  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end