class DropCreateJwtDenylists < ActiveRecord::Migration[6.0]
  def up
    drop_table :jwt_denylists, if_exists: true
  end

  def down
    create_table :jwt_denylists do |t|
      t.string :jti
      t.datetime :exp
      t.timestamps
    end
  end
end
