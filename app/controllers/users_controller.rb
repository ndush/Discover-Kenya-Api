class UsersController < ApplicationController
  # Create a new user
  def create
    # Initialize the user with the parameters from the request
    user = User.new(user_params)
    
    # Attempt to save the user
    if user.save
      # If the user is saved successfully, respond with success
      render json: { message: 'User created successfully', user: user }, status: :created
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
end
