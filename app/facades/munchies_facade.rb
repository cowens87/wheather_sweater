class MunchiesFacade
  def self.businesses(munchies_info)
    destination   = munchies_info[:destination]
    food_category = munchies_info[:food]
    businesses    = YelpService.businesses(destination, food_category)
    Munchie.new(Business.new(businesses), RoadTripFacade.get_trip(munchies_info))
  end
end