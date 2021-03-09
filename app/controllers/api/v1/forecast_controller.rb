class Api::V1::ForecastController < ApplicationController
  def index
    if params[:location].present?
      render json: ForecastSerializer.new(ForecastFacade.forecast(params[:location]))
    else
      render json: { message: 'unsuccessful', error: 'Unable to find location' },
      status: :not_found
    end
  end
end