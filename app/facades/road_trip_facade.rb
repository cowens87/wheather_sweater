class RoadTripFacade
  class << self
    include Locatable

    def get_trip(trip_deets)
      trip = MapService.directions(trip_deets[:origin], trip_deets[:destination])
      if trip[:info][:statuscode] != 402
        destination_weather = get_forecast_weather(trip_deets[:destination])
        weather_time        = get_eta_weather_time(trip, destination_weather)
        Roadtrip.new(trip, trip_deets[:origin], trip_deets[:destination], weather_time)
      else
        weather_time = nil
        Roadtrip.new(trip, trip_deets[:origin], trip_deets[:destination], weather_time)
      end
    end

    def get_forecast_weather(destination)
      WeatherService.get_weather(coords(destination)[:lat], coords(destination)[:lng])
    end

    def get_eta_weather_time(trip, destination_weather)
      eta_weather_time = (Time.now + (trip[:route][:realTime]))
      destination_weather(eta_weather_time, destination_weather)
    end

    def destination_weather(eta_weather_time, destination_weather)
      answer = destination_weather[:hourly].select do |hourly|
        time = (Time.at(hourly[:dt])).strftime('%H:%M:%S')
        time_rounding(eta_weather_time).strftime('%H:%M:%S') == time
      end.first
      HourlyWeather.new(answer)
    end

    def time_rounding(eta_weather_time)
      if eta_weather_time.strftime('%M').to_i < 30
        eta_weather_time.beginning_of_hour
      else
        (eta_weather_time + 1).beginning_of_hour
      end
      eta_weather_time.beginning_of_hour if eta_weather_time.strftime('%M').to_i < 30 ||
      (eta_weather_time + 1).beginning_of_hour
    end
  end
end