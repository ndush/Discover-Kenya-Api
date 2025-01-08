# app/models/jwt_blacklist.rb
class JwtBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Blacklist
end
