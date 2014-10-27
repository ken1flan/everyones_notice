class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nickname
      t.integer :club_id

      t.timestamps
    end
  end
end
