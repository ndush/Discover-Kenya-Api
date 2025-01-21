# app/models/user.rb
class User < ApplicationRecord
  # Devise modules and JWT setup
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Enum for role management
 enum role: [:user, :moderator, :admin]

  # Set default role for new users
  after_initialize :set_default_role, if: :new_record?

  # Associations
  has_many :posts

  # Returns posts created today
  def posts_today
    posts.where(created_at: Time.zone.today.all_day)
  end

  # Generate JWT token
  def generate_jwt_token
    JWT.encode({ user_id: self.id, exp: 24.hours.from_now.to_i }, Rails.application.secret_key_base)
  end

  private

  # Set default role for new users if no role is assigned
  def set_default_role
    self.role ||= :user
  end
end
