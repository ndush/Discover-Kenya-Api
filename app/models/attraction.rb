class Attraction < ApplicationRecord
  belongs_to :user
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  geocoded_by :address # Replace `address` with your actual field for location
  after_validation :geocode, if: :will_save_change_to_address?

  def self.cached_near_location(location, distance = 5)
    key = "attractions:near_location:#{location}:#{distance}"
    redis = Redis.new

    cached_data = redis.get(key)
    return Marshal.load(cached_data) if cached_data

    attractions = near(location, distance)
    redis.set(key, Marshal.dump(attractions), ex: 1.hour)
    attractions
  end
end
