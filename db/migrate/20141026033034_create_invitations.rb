class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :mail_address
      t.text :message
      t.integer :user_id
      t.string :token
      t.datetime :expired_at

      t.timestamps
    end
  end
end
