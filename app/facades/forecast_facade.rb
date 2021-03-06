class ForecastFacade
  def self.get_forecast(location)
    map = self.get_coordinates(location)
    lat = map[:results][0][:locations][0][:latLng][:lat]
    lng = map[:results][0][:locations][0][:latLng][:lng]
    self.get_weather(lat, lng)
  end

  def self.get_weather(lat, lng)
    weather = self.weather(lat, lng)
    current_weather = CurrentWeather.new(weather[:current])
    daily_weather = self.daily_weather(weather)
    hourly_weather = self.hourly_weather(weather)
    Forecast.new(current_weather, daily_weather, hourly_weather)
  end

  def self.get_coordinates(location)
    MapService.get_coordinates(location)
  end

  def self.get_forecast_weather(destination)
    map = self.get_coordinates(destination)
    self.get_destination_weather(map)
  end

  def self.get_destination_weather(lat, lng)
    weather = self.weather(lat, lng)
    self.get_many_hourly_weather(weather)
  end

  def self.weather(lat, lng)
    WeatherService.get_weather(lat, lng)
  end

  def self.get_many_hourly_weather(weather)
    (weather[:hourly]).map do |hour|
      HourlyWeather.new(hour)
    end
  end

  def self.hourly_weather(weather)
    (weather[:hourly][0..7]).map do |hour|
      HourlyWeather.new(hour)
    end
  end

  def self.daily_weather(weather)
    (weather[:daily][0..4]).map do |day|
      DailyWeather.new(day)
    end
  end
end
