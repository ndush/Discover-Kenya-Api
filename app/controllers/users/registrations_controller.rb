# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      token = generate_redis_token(@user)
      render json: { user: @user, token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def generate_redis_token(user)
    token = SecureRandom.hex(20)
    redis.setex("user:#{user.id}:session_token", 24.hours.to_i, token)
    token
  end

  def redis
    @redis ||= Redis.new
  end
end