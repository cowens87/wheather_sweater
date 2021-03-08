class Api::V1::BackgroundsController < ApplicationController
  def index
    if location_params[:location].empty?
      render json: { body: generate_error }, status: 400
    else
      image = ImageFacade.location_photos(location_params[:location])
      render json: ImageSerializer.new(image)
    end
  end

  private

  def generate_error
    ['Unable to find image without location']
  end

  def location_params
    params.permit(:location)
  end
end