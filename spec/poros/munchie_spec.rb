require 'rails_helper'

RSpec.describe Munchie, :vcr do
   before :each do
    munchies_params = {
                      origin: 'Denver, CO',
                      destination: 'Pueblo, CO',
                      food_category: 'hamburger'
                    }
    arrival_time    = 1615235905
    businesses      = YelpService.businesses(munchies_params[:destination], arrival_time, munchies_params[:food_category])
    @biz            = Business.new(businesses)
    @roadtrip       = RoadTripFacade.get_trip(munchies_params)
  end
  
  it 'exist and has attributes' do
    munchie = Munchie.new(@biz, @roadtrip)

    expect(munchie.destination_city).to be_a String
    expect(munchie.travel_time).to be_a String

    expect(munchie.travel_time).to eq('01:44:22')
    expect(munchie.restaurant[:name]).to eq('Bingo Burger')

    check_hash_structure(munchie.forecast, :summary, String)
    check_hash_structure(munchie.forecast, :temperature, Numeric)
    check_hash_structure(munchie.restaurant, :name, String)
    check_hash_structure(munchie.restaurant, :address, String)
  end
end