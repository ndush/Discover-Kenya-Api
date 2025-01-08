class Users::SessionsController < ApplicationController
  # Skip the default session-based authentication
  skip_before_action :authenticate_user!, only: [:create]

  # Handles user login (generates JWT token)
  def create
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      # Create JWT token manually or rely on Devise's JWT strategy
      token = JwtService.encode(user_id: user.id)  # Use your own JwtService or the one provided by the gem

      render json: { message: 'Signed in successfully', token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # Handles user logout (stateless, so no actual session destruction)
  def destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
