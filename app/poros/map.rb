class Map
  attr_reader :id,
              :latitude,
              :longitude,
              :status_code,
              :messages
              
  def initialize(data)
    @id = nil
    @status_code = data[:info][:statuscode]
    @messages = data[:info][:messages]
    if !data[:results][0][:locations][0].nil?
      @latitude = data[:results][0][:locations][0][:latLng][:lat]
      @longitude = data[:results][0][:locations][0][:latLng][:lng]
    end
  end
end