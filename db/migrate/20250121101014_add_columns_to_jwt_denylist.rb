class AddColumnsToJwtDenylist < ActiveRecord::Migration[7.2]
  def change
    add_column :jwt_denylists, :jti, :string, null: false
    add_column :jwt_denylists, :revoked_at, :datetime
    add_column :jwt_denylists, :location, :st_point, geographic: true

    add_index :jwt_denylists, :jti, unique: true
    add_index :jwt_denylists, :location, using: :gist
  end
end
