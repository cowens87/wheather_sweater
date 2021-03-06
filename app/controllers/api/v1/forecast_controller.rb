class Api::V1::ForecastController < ApplicationController
  def index
    if params[:location]
      render json: ForecastFacade.forecast(params[:location])
    else
      render json: { message: 'unsuccessful', error: 'Location not found.' },
      status: :bad_request
    end
  end
end