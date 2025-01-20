class User < ApplicationRecord
  # Include JTIMatcher for revocation strategy
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Devise modules for authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  # Enum for role management
  enum role: { user: 0, moderator: 1, admin: 2 }

  # Set default role for new users if no role is assigned
  after_initialize :set_default_role, if: :new_record?

  # Associations (assuming a User has many posts)
  has_many :posts

  # Returns posts created today
  def posts_today
    posts.where(created_at: Time.zone.today.all_day)
  end

  private

  # Set default role for new users if no role is assigned
  def set_default_role
    self.role ||= :user
  end
end
