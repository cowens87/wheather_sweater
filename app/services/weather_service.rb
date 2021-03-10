class WeatherService < ApplicationService
  class << self
    def get_weather(lat, lon)
      response = connection(weather).get("/data/2.5/onecall?") do |req|
        req.params[:appid]   = ENV['OPEN_WEATHER_API_KEY']
        req.params[:lat]     = lat
        req.params[:lon]     = lon
        req.params[:exclude] = "minutely,alerts"
        req.params[:units]   = 'imperial'
      end
      parse_data(response)
    end
  end
end