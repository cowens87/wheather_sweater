class Api::V1::RoadTripController < ApplicationController
  def create
    user = User.find_by(api_key: road_trip_params[:api_key])
    if user && (find_empty_values(road_trip_params) == false)
      roadtrip = RoadTripFacade.get_trip(road_trip_params)
      render json: RoadtripSerializer.new(roadtrip)
    elsif find_empty_values(road_trip_params)
      render json: { body: generate_error }, status: 404
    elsif bad_api_key(road_trip_params, user)
      render json: { body: api_error }, status: 401
    end
  end

  private

  def find_empty_values(road_trip_params)
    road_trip_params[:origin].empty? || road_trip_params[:destination].empty?
  end

  def bad_api_key(road_trip_params, user)
    user.nil? || road_trip_params[:api_key].empty?
    return true
  end

  def api_error
    'Missing/incorrect API key. Please try again'
  end

  def generate_error
    'Missing/empty fields. Please try again'
  end

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end
end
