module Users
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:login]

    def login
      @user = User.find_by(email: session_params[:email])
      if @user&.authenticate(session_params[:password])
        token = generate_redis_token(@user)
        render json: { user: @user, token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    def logout
      redis.del("user:#{current_user.id}:session_token")
      render json: { message: 'Logged out successfully' }, status: :ok
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
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
end
