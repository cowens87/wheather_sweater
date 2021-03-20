class Munchie
  attr_reader :destination_city,
              :travel_time,
              :forecast,
              :restaurant
              
  def initialize(business, roadtrip)
    @destination_city = roadtrip.end_city
    @travel_time      = roadtrip.travel_time
    @forecast         = {
                          summary: roadtrip.weather_at_eta[:conditions],
                          temperature: roadtrip.weather_at_eta[:temperature]
                        }
    @restaurant       = {
                          name: business.name,
                          address: business.address
                        }
  end
end