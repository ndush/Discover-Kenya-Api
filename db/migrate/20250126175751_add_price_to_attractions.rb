class AddPriceToAttractions < ActiveRecord::Migration[7.2]
  def change
    add_column :attractions, :price, :string
  end
end
