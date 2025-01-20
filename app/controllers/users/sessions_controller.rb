# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
   skip_before_action :authenticate_user!, only: [:create]
  # Disable the default session handling by overriding the create action
  def create
    super do |resource|
      if resource.persisted?  # Check if user was successfully created
        token = generate_jwt(resource)  # Generate JWT token
        render json: { user: resource, token: token }, status: :created and return
      end
    end
  end

  private

  # Method to generate JWT token
  def generate_jwt(user)
    JWT.encode(
      { user_id: user.id, exp: 24.hours.from_now.to_i },  # JWT payload
      Rails.application.secret_key_base  # Secret key to sign JWT
    )
  end


  # def destroy
  #   current_user.jwt_denylist.create!(jti: request.headers['Authorization'].split(' ').last)
  #   head :no_content
  # end

end
