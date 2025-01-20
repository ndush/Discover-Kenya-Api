class DropJwtBlacklistsAndJwtDenylists < ActiveRecord::Migration[7.2]
  def up
    # Drop jwt_blacklists table if it exists
    if table_exists?(:jwt_blacklists)
      drop_table :jwt_blacklists
    end

    # Drop jwt_denylists table if it exists
    if table_exists?(:jwt_denylists)
      drop_table :jwt_denylists
    end
  end

  def down
    # Optionally, you can define how to recreate the tables if needed
    # For example:
    create_table :jwt_blacklists do |t|
      t.string :jti
      t.timestamps
    end

    create_table :jwt_denylists do |t|
      t.string :jti
      t.timestamps
    end
  end
end