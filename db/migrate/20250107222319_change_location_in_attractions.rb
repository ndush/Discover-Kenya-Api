class ChangeLocationInAttractions < ActiveRecord::Migration[7.2]
  def change
    # Change the location column to geometry(Point, 4326)
    change_column :attractions, :location, "geometry(Point, 4326)", using: "ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)"
  end
end