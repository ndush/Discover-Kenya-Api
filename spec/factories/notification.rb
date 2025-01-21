# factories/notifications.rb
FactoryBot.define do
  factory :notification do
    message { "Sample notification message" }
    status { :unread }
    user
  end
end
