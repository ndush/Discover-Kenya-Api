require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  test "should create notification" do
  user = FactoryBot.create(:user) # Ensure this is defined in your factories
  notification = FactoryBot.create(:notification, user: user)

  assert notification.save
 end
end
