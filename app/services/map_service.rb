class MapService < ApplicationService
  class << self
    def coordinates_by_location(location)
      response = connection(mapquest).get('/geocoding/v1/address?') do |req|
        req.params[:key]      = ENV['MAPQUEST_API_KEY']
        req.params[:location] = location
      end
      parse_data(response)
    end

    def directions(start_location, end_location)
      response = connection(mapquest).get('/directions/v2/route?') do |req|
        req.params[:key]  = ENV['MAPQUEST_API_KEY']
        req.params[:from] = start_location
        req.params[:to]   = end_location
      end
      parse_data(response)
    end
  end
end