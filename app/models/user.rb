
class User < ApplicationRecord
   has_secure_password
   validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
  enum role: { user: 0, moderator: 1, admin: 2 }

  after_initialize :set_default_role, if: :new_record?

  has_many :posts, dependent: :destroy

  def posts_today
    posts.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
