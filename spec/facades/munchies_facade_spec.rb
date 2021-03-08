require 'rails_helper'

RSpec.describe 'MunchiesFacade', :vcr do
  before :each do
    munchies_params = {
                      origin: 'Denver, CO',
                      destination: 'Pueblo, CO',
                      food_category: 'hamburger'
                    }
    arrival_time    = 1615235905
    @businesses     = YelpService.businesses(munchies_params[:destination], arrival_time, munchies_params[:food_category])
  end

  it 'can return a Munchie object after calling a YelpService' do
    biz = @businesses[:businesses][0]
    expect(@businesses).to be_a Hash

    check_hash_structure(@businesses, :businesses, Array)
    check_hash_structure(biz, :categories, Array )
    check_hash_structure(biz, :coordinates, Hash )
    check_hash_structure(biz, :location, Hash )
    check_hash_structure(biz[:categories][0], :alias, String)
    check_hash_structure(biz[:coordinates], :latitude, Float)
    check_hash_structure(biz[:coordinates], :longitude, Float)
    check_hash_structure(biz[:location], :city, String)
    check_hash_structure(biz[:location], :state, String)
    check_hash_structure(biz[:location], :address1, String)
    check_hash_structure(biz[:location], :zip_code, String)
  end
end