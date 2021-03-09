class ForecastFacade
  class << self
    include Locatable

    def forecast(loc)
      weather = WeatherService.get_weather(coords(loc)[:lat], coords(loc)[:lng])
      Forecast.new(current_weather(weather), daily_weather(weather), hourly_weather(weather))
    end

    def current_weather(weather)
      CurrentWeather.new(weather[:current])
    end

    def daily_weather(weather)
      weather[:daily][0..4].map { |day| DailyWeather.new(day) }
    end

    def hourly_weather(weather)
      weather[:hourly][0..7].map { |hour| HourlyWeather.new(hour) }
    end

    def get_forecast_weather(destination)
      map = MapService.coordinates_by_location(location)
      get_destination_weather(map)
    end

    def get_destination_weather(lat, lng)
      weather = WeatherService.get_weather(lat, lng)
      weather[:hourly].map { |hour| HourlyWeather.new(hour) }
    end
  end
end
