class MapFacade
  def self.get_coordinates(location)
    coordinates = MapService.coordinates_by_location(location)
    Map.new(coordinates)
  end

  def self.get_trip(origin, destination)
    trip_directions = MapService.directions(origin, destination)
  end
end