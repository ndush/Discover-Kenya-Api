# app/models/jwt_denylist.rb
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  # Validations
  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true

  # Scopes
  scope :expired, -> { where("exp < ?", Time.current) }

  # Class Methods
  def self.token_revoked?(jti)
    exists?(jti: jti)
  end

  # Periodically cleanup expired tokens from the denylist
  def self.cleanup_expired
    expired.destroy_all
  end

  # Additional method to revoke token on logout or other events
  def self.revoke_jwt_token!(jti)
    create!(jti: jti, exp: Time.current)  # Add current time as exp or use the actual token expiration time
  end

  # Callback to clean up expired tokens regularly
  def self.cleanup_expired_tokens!
    cleanup_expired
  end
end
