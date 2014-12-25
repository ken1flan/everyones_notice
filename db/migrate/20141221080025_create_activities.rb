class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :type_id
      t.integer :user_id
      t.integer :notice_id
      t.integer :reply_id

      t.timestamps
    end

    add_index :activities, [:type_id]
    add_index :activities, [:user_id]
    add_index :activities, [:notice_id]
    add_index :activities, [:reply_id]
    add_index :activities, [:type_id, :user_id, :notice_id, :reply_id], name: "index_activities_unique_key", unique: true
    add_index :activities, [:created_at]
  end
end
