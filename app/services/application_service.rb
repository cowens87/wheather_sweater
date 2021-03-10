class ApplicationService 
  class << self
    private

    def weather
      'https://api.openweathermap.org'
    end

    def mapquest
      'https://www.mapquestapi.com'
    end

    def unsplash
      'https://api.unsplash.com/'
    end

    def connection(root)
      Faraday.new(url: root)
    end

    def parse_data(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end 