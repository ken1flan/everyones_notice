class CreateClubUsers < ActiveRecord::Migration
  def change
    create_table :club_users do |t|
      t.integer :club_id
      t.integer :user_id

      t.index [:club_id]
      t.index [:user_id]
    end
  end
end
