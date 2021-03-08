class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: sessions_params[:email])
    if user && user.authenticate(sessions_params[:password])
      render json: UsersSerializer.new(user), status: 200
    else
      render json: { body: generate_error }, status: 404
    end
  end

  private

  def generate_error
    ['Invaild creditials. Please try again']
  end

  def sessions_params
    JSON.parse(request.body.read, symbolize_names: true)
  end
end