class Api::V1::RoadTripController < ApplicationController
  def create
    user = User.find_by(api_key: road_trip_params[:api_key])
    if user && (has_req_values?(road_trip_params) == false)
      roadtrip = RoadTripFacade.get_trip(road_trip_params)
      render json: RoadtripSerializer.new(roadtrip)
    elsif has_req_values?(road_trip_params)
      render json: { body: 'Missing/empty fields. Please try again' }, status: 404
    elsif invalid_api_key?(road_trip_params, user)
      render json: { body: 'Missing/incorrect API key. Please try again' }, status: 401
    end
  end

  private

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end

  def has_req_values?(road_trip_params)
    road_trip_params[:origin].empty? || road_trip_params[:destination].empty?
  end

  def invalid_api_key?(road_trip_params, user)
    user.nil? || road_trip_params[:api_key].empty?
    return true
  end
end
