class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylists'


  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true


  scope :expired, -> { where("exp < ?", Time.current) }


  def self.token_revoked?(jti)
    exists?(jti: jti)
  end


  def self.cleanup_expired
    expired.delete_all  
  end


  def self.revoke_jwt_token!(jti, exp)
    create!(jti: jti, exp: exp)
  end

  def self.cleanup_expired_tokens!
    cleanup_expired
  end
end
