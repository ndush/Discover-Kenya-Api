class CreateJwtDenylists < ActiveRecord::Migration[7.2]
   def change
    create_table :jwt_denylists do |t|
      t.string :jti, null: false
      t.datetime :revoked_at, null: false
      
      t.timestamps
    end
  end
end
