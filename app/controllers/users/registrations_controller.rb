class Users::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  # Override the create action to handle Redis session token
  def create
    super do |resource|
      if resource.persisted?
        # Generate a session token and store it in Redis
        token = generate_redis_token(resource)
        render json: { user: resource, token: token }, status: :created and return
      end
    end
  end

  private

  # Method to generate Redis session token
  def generate_redis_token(user)
    # Set a token in Redis (e.g., store the user ID with a TTL)
    token = SecureRandom.hex(20)
    redis.setex("user:#{user.id}:session_token", 24.hours.to_i, token) # Expiry in 24 hours
    token
  end

  # Redis instance setup
  def redis
    @redis ||= Redis.new
  end
end
