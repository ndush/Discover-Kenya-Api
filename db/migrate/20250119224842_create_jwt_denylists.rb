class CreateJwtDenylists < ActiveRecord::Migration[7.2]
  unless table_exists?(:jwt_denylists)
      create_table :jwt_denylists do |t|
        t.string :jti, null: false

        t.timestamps
      end

      add_index :jwt_denylists, :jti, unique: true
    end
end
