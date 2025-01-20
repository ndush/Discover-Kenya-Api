class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def current_user
    @current_user
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last  # Extract token from the Authorization header
    
    Rails.logger.debug("Authorization Header: #{request.headers['Authorization']}")

    if token
      decoded_token = JwtService.decode(token)  # Decode the token
      Rails.logger.debug("Decoded token: #{decoded_token}")
      
      if decoded_token && decoded_token['user_id']  # Ensure 'user_id' is in the decoded token
        user_id = decoded_token['user_id']
        @current_user = User.find_by(id: user_id)

        Rails.logger.debug("Current User: #{@current_user.inspect}")
        
        if @current_user.nil?
          render json: { error: 'User not found' }, status: :unauthorized
        else
          # Check if the token is revoked
          jti = decoded_token['jti']
          if JwtDenylist.exists?(jti: jti)
            render json: { error: 'Token has been revoked' }, status: :unauthorized
          end
        end
      else
        render json: { error: 'Invalid token payload' }, status: :unauthorized
      end
    else
      render json: { error: 'Token missing' }, status: :unauthorized
    end
  end
end
