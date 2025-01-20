class AddCountryToAttractions < ActiveRecord::Migration[7.0]
  def change
    add_column :attractions, :country, :string
  end
end
