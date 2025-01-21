class UsersController < ApplicationController
  before_action :authorize_request, only: [:logout]

  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session_token = SecureRandom.hex(64)
      # Store session token in Redis with a 1-hour expiry
      $redis.setex("user_session_#{user.id}", 1.hour.to_i, session_token)
      render json: { message: 'Logged in successfully', session_token: session_token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def logout
    $redis.del("user_session_#{current_user.id}")
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def authorize_request
    session_token = request.headers['Authorization']
    user_id = current_user.id
    if $redis.get("user_session_#{user_id}") != session_token
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    user_id = request.headers['X-User-Id']
    @current_user ||= User.find(user_id) if user_id
  end
end
