module Locatable
  def coords(loc)
    map = MapService.coordinates_by_location(loc)
    { lat: map[:results][0][:locations][0][:latLng][:lat],
    lng: map[:results][0][:locations][0][:latLng][:lng] }
  end
end 