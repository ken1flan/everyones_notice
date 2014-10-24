class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :mail_address, null:false
      t.text :message
      t.string :token, null: false
      t.datetime :expire_at, null:false

      t.timestamps
    end
  end
end
