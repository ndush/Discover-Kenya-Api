class DropJwtDenylists < ActiveRecord::Migration[7.2]
  def change
    drop_table :jwt_denylists
  end
end
