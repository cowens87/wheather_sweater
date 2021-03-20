class MunchiesFacade
  def self.businesses(munchies_info)
    destination   = munchies_info[:destination]
    arrival_time  = (Time.now + (MapService.directions(munchies_info[:origin], destination))[:route][:realTime]).to_i
    food_category = munchies_info[:food]
    businesses    = YelpService.businesses(destination, arrival_time, food_category)
    Munchie.new(Business.new(businesses), RoadTripFacade.get_trip(munchies_info))
  end
end