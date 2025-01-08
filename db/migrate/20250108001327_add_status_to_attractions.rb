class AddStatusToAttractions < ActiveRecord::Migration[7.0]
  def change
    add_column :attractions, :status, :integer, default: 0
  end
end
