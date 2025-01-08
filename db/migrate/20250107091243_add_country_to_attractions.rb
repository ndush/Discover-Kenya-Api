class AddCountryToAttractions < ActiveRecord::Migration[8.0]
  def change
    add_column :attractions, :country, :string
  end
end
