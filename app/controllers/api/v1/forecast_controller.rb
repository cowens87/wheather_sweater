class Api::V1::ForecastController < ApplicationController
  def index
    if location_params[:location].empty?
      render json: { body: generate_error }, status: 404
    else
      forecast = ForecastFacade.get_forecast(location_params)
      render json: ForecastSerializer.new(forecast)
    end
  end

  private

  def generate_error
    ['Unable to find forecast without location']
  end

  def location_params
    params.permit(:location)
  end
end