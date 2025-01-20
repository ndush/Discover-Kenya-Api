class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  # Define the table name explicitly (assuming the table name is 'jwt_denylists')
  self.table_name = 'jwt_denylists'

  # Method to revoke tokens for a user
  def self.revoke_tokens_for_user(user)
    create!(jti: user.jti, revoked_at: Time.current)
  end

  # Check if a token has been revoked by matching the JTI
  def self.revoked?(token, _)
    where(jti: token['jti']).exists?
  end
end
