class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylists'

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
    expired.delete_all  # Using delete_all for performance
  end

  # Revoke token with the actual expiration time
  def self.revoke_jwt_token!(jti, exp)
    create!(jti: jti, exp: exp)
  end

  # Callback to clean up expired tokens regularly (can be triggered by a background job)
  def self.cleanup_expired_tokens!
    cleanup_expired
  end
end
