class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname
      t.integer :club_id, null: false, default: 1
      t.boolean :admin, null: false, default: false

      t.timestamps
    end

    add_index :users, :club_id
  end
end
