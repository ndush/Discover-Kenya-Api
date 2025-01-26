class AddAddressToAttractions < ActiveRecord::Migration[7.2]
  def change
    add_column :attractions, :address, :string
  end
end
