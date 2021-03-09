class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: sessions_params[:email])
    if user && user.authenticate(sessions_params[:password])
      render json: UsersSerializer.new(user), status: 200
    else
      render json: { error: 'invalid credentials' }, status: :bad_request
    end
  end

  private

  def sessions_params
    JSON.parse(request.body.read, symbolize_names: true)
  end
end