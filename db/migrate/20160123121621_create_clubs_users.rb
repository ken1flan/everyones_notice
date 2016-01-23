class CreateClubsUsers < ActiveRecord::Migration
  def change
    create_table :clubs_users do |t|
      t.references :club, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
