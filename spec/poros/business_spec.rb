require 'rails_helper'

RSpec.describe Business, :vcr do
  before :each do
    munchies_params = {
                      origin: 'Denver, CO',
                      destination: 'Pueblo, CO',
                      food_category: 'hamburger'
                    }
    arrival_time    = 1615235905
    businesses      = YelpService.businesses(munchies_params[:destination], arrival_time, munchies_params[:food_category])
    @biz            = Business.new(businesses)
  end

  it 'exists and has attributes' do
    expect(@biz).to be_a Business
    expect(@biz.name).to be_a String
    expect(@biz.name).to eq('Bingo Burger')
    expect(@biz.name).to_not eq('Delicious Burgers')
    expect(@biz.address).to be_a String
    expect(@biz.address).to_not be_an Array
    expect(@biz.address).to eq('101 Central Plz')
    expect(@biz.address).to_not be_empty
  end
end