class Api::V1::BackgroundsController < ApplicationController
  def index
    if location_params[:location].empty?
      render json: { body: 'Unable to find image without location' }, status: 400
    else
      image = ImageFacade.location_photos(location_params[:location])
      render json: ImageSerializer.new(image)
    end
  end

  private

  def location_params
    params.permit(:location)
  end
end