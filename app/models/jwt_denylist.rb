class JwtDenylist < ApplicationRecord
    include Devise::JWT::RevocationStrategies::Denylist
  # Validations
  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true

  # Scopes
  scope :expired, -> { where("exp < ?", Time.now) }

  # Class methods
  def self.token_revoked?(jti)
    exists?(jti: jti)
  end
end
