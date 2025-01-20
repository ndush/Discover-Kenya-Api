# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
   skip_before_action :authenticate_user!, only: [:create]
  # Disable the default session handling by overriding the create action
 def create
    user = User.find_for_database_authentication(email: params[:email])

    if user && user.valid_password?(params[:password])
      token = generate_jwt(user)
      render json: { user: user, token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  # Method to generate JWT token
  def generate_jwt(user)
    JWT.encode(
      { user_id: user.id, exp: 24.hours.from_now.to_i },
      Rails.application.secret_key_base
    )
  end


  def destroy
    # Here, store the JWT ID in a denylist for revocation
    current_user.jwt_denylist.create!(jti: request.headers['Authorization'].split(' ').last)
    head :no_content
  end

end
