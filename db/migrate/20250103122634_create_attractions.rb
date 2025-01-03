class CreateAttractions < ActiveRecord::Migration[8.0]
  def change
    create_table :attractions do |t|
      t.string :name
      t.text :description
      t.string :location
      t.string :category
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
