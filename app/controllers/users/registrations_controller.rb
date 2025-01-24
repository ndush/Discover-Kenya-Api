class Users::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
 def create
    super do |resource|
      if resource.persisted?
        token = generate_redis_token(resource)
        render json: { user: resource, token: token }, status: :created and return
      end
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
