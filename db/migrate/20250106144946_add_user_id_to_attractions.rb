class AddUserIdToAttractions < ActiveRecord::Migration[7.0]
  def change
    add_column :attractions, :user_id, :integer
  end
end
