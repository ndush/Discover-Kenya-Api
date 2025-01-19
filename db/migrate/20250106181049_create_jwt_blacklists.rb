class CreateJwtBlacklists < ActiveRecord::Migration[6.0]
  def change
    create_table :jwt_blacklists do |t|
      t.string :jti, null: false
      t.datetime :created_at, null: false
    end

    add_index :jwt_blacklists, :jti, unique: true
  end
end