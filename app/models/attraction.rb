class Attraction < ApplicationRecord
  belongs_to :user
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  # Validations for name, latitude, and longitude
  validates :name, presence: true
  validates :latitude, numericality: true
  validates :longitude, numericality: true

  # Validating that the location is a valid geography point (it will be set during creation or update)
  validates :location, presence: true

  # Scope to find attractions near a specific point (latitude, longitude) with optional distance parameter (default 5 km)
  scope :near, ->(lat, lon, distance = 5) {
    where("ST_DWithin(location, ST_SetSRID(ST_MakePoint(?, ?), 4326), ?)", lon, lat, distance * 1000)
  }

  # Optional method to calculate the distance from a point (latitude, longitude)
  def distance_from(lat, lon)
    Attraction.connection.select_value(
      "SELECT ST_Distance(location, ST_SetSRID(ST_MakePoint(?, ?), 4326))", 
      [lon, lat]
    )
  end
end
