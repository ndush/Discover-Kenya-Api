class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :message, null: false
      t.integer :status, default: 0, null: false  # status can be read/unread
      t.timestamps
    end
  end
end
