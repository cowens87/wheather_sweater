class Api::V1::UsersController < ApplicationController
  def create
    ActiveRecord::Base.connection.reset_pk_sequence!('users')
    user = User.new(user_params)
    if user.save
      render json: UsersSerializer.new(user), status: 201
    elsif !user.save
      render json: { body: generate_error(user) }, status: 404 
    end
  end

  private

  def generate_error(user)
    error = ''
    user.errors.messages.map do |validation, message|
      error += "#{validation.capitalize} (#{message[0]}); "
    end
  end

  def user_params
    JSON.parse(request.body.read, symbolize_names: true)
  end
end