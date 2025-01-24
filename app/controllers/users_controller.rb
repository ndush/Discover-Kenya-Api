
class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register, :login]

  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'User  created successfully', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session_token = SecureRandom.hex(64)
      $redis.setex("user:#{user.id}:session_token", 1.hour.to_i, session_token)
      render json: { message: 'Logged in successfully', session_token: "#{user.id}:#{session_token}" }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def logout
    if current_user
      $redis.del("user:#{current_user.id}:session_token")
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end