class ChangeLocationInAttractions < ActiveRecord::Migration[7.0]
  def change
    change_column :attractions, :location, "geography(Point, 4326)", using: "ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)"
    add_index :attractions, :location, using: :gist
  end
end
