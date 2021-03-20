require 'rails_helper'

RSpec.describe YelpService, :vcr do
  it 'find an open restaurant for the food category' do
    food_category = "hamburger"
    location      = "Denver, CO"
    arrival_time  = 1615235905

    response = YelpService.businesses(location, arrival_time, food_category)
    business = response[:businesses][0]
    biz_loc  = response[:businesses][0][:location]

    expect(response).to be_a Hash
    expect(business).to be_a Hash
    expect(biz_loc[:display_address][0]).to be_a(String)

    check_hash_structure(response, :businesses, Array)
    check_hash_structure(response, :businesses, Array)
    check_hash_structure(response, :businesses, Array)
    check_hash_structure(business, :name, String)
    check_hash_structure(business, :location, Hash)
    check_hash_structure(biz_loc, :display_address, Array)
  end
end