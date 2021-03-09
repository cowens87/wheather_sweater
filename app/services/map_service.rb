  
class MapService
  class << self
    def coordinates_by_location(location)
      response = connection.get('/geocoding/v1/address?') do |req|
        req.params[:key]      = ENV['MAPQUEST_API_KEY']
        req.params[:location] = location
      end
      parse_data(response)
    end

    def directions(start_location, end_location)
      response = connection.get('/directions/v2/route?') do |req|
        req.params[:key]  = ENV['MAPQUEST_API_KEY']
        req.params[:from] = start_location
        req.params[:to]   = end_location
      end
      parse_data(response)
    end

    private
    
    def connection 
      Faraday.new(url: 'https://www.mapquestapi.com')
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end