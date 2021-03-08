class Roadtrip
  attr_reader :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta

  def initialize(data, origin, destination, weather)
    @start_city = origin
    @end_city = destination
    if data[:info][:statuscode] == 402
      @travel_time = 'impossible route'
      @weather_at_eta = 'no data available'
    else
      @travel_time = data[:route][:formattedTime]
      @weather_at_eta = {
        temperature: weather.temperature,
        conditions: weather.conditions
      }
    end
  end
end