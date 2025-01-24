class DropJwtBlacklistsAndJwtDenylists < ActiveRecord::Migration[7.2]
  def up

    if table_exists?(:jwt_blacklists)
      drop_table :jwt_blacklists
    end

   
    if table_exists?(:jwt_denylists)
      drop_table :jwt_denylists
    end
  end

  def down
  
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