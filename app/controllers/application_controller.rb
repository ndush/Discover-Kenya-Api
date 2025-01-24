
class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def current_user
    @current_user
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last 
    
    Rails.logger.debug("Authorization Header: #{request.headers['Authorization']}")

    if token
      user = find_user_by_session_token(token)

      if user
        @current_user = user
        Rails.logger.debug("Current User: #{@current_user.inspect}")
      else
        render json: { error: 'Invalid session token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token missing' }, status: :unauthorized
    end
  end

  def find_user_by_session_token(token)
    user_id, stored_token = token.split(':')  
    user = User.find_by(id: user_id)
    if user && redis.get("user:#{user.id}:session_token") == stored_token
      user
    end
  end

  def redis
    @redis ||= Redis.new
  end
end