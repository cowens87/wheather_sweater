class Api::V1::MunchiesController < ApplicationController
  def index
    munchies = MunchiesFacade.businesses(munchies_params)
    render json: MunchieSerializer.new(munchies)
  end

  private
  def munchies_params
    params.permit(:origin, :destination, :food)
  end
end