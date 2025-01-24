class Attraction < ApplicationRecord
  belongs_to :user
  enum :status, { pending: 0, approved: 1, rejected: 2 }
  def self.cached_near(lat, lon, distance = 5)
    key = "attractions:near:#{lat}:#{lon}:#{distance}"
    redis = Redis.new

    cached_data = redis.get(key)
    return Marshal.load(cached_data) if cached_data

    attractions = near(lat, lon, distance)
    redis.set(key, Marshal.dump(attractions), ex: 1.hour)
    attractions
  end
end
