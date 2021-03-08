class WeatherService
  class << self
    def get_weather(lat, lon)
      response = connection.get("/data/2.5/onecall?") do |req|
        req.params[:appid]   = ENV['OPEN_WEATHER_API_KEY']
        req.params[:lat]     = lat
        req.params[:lon]     = lon
        req.params[:exclude] = "minutely,alerts"
        req.params[:units]   = 'imperial'
      end
      parse_data(response)
    end

    private

    def connection
      Faraday.new(url: 'http://api.openweathermap.org')
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end