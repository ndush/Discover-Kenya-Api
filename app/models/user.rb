class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { user: 0, moderator: 1, admin: 2 }

  # Optional: Set default role for new users
  after_initialize :set_default_role, if: :new_record?

  # Assuming the User has many posts
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
