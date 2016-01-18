class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :mail_address, null: false
      t.text :message
      t.integer :club_id, null: false
      t.integer :user_id
      t.boolean :admin, null: false, default: false
      t.string :token, null: false
      t.datetime :expired_at, null: false

      t.timestamps
    end
  end
end
