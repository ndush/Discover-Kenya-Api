class UsersController < ApplicationController
  # Create a new user
  def create
    # Initialize the user with the parameters from the request
    user = User.new(user_params)

    # Attempt to save the user
    if user.save
      # Generate a JWT token for the newly created user
      token = generate_jwt(user)

      # If the user is saved successfully, respond with success and token
      render json: { message: 'User created successfully', user: user, token: token }, status: :created
    else
      # If user creation fails (invalid data), respond with errors
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Define strong parameters for user creation
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # Method to generate JWT token
  def generate_jwt(user)
    JWT.encode(
      { user_id: user.id, exp: 24.hours.from_now.to_i, jti: SecureRandom.uuid },  # Add a jti (JWT ID) for future revocation
      Rails.application.secret_key_base
    )
  end
end
