# spec/factories/jwt_denylists.rb
FactoryBot.define do
  factory :jwt_denylist do
    jti { SecureRandom.uuid }
    exp { Time.current + 1.hour }
    location { RGeo::Geos.factory(srid: 4326).point(-122.4194, 37.7749) } # Example location (San Francisco)
  end
end
#