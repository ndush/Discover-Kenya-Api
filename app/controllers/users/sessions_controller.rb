module Users
  class SessionsController < ApplicationController
    # skip_before_action :verify_signed_out_user, only: [:create]

    def create
      user = User.find_by_email(params[:user][:email])
      if user && user.valid_password?(params[:user][:password])
        token = generate_redis_token(user)
        render json: { token: token, user: user }
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end

    private

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
