class CreateJwtDenylist < ActiveRecord::Migration[7.2]
  def change
    create_table :jwt_denylists do |t|
      t.string :jti, null: false
      t.datetime :revoked_at
      t.st_point :location, geographic: true # Adding geospatial column for location

      t.timestamps
    end

    # Adding unique index on jti
    add_index :jwt_denylists, :jti, unique: true

    # Geospatial index on location column for efficient spatial queries
    add_index :jwt_denylists, :location, using: :gist
  end
end
