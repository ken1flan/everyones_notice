class AddAdvertisementIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :advertisement_id, :integer
  end

  def up
    remove_index :activities, name: 'index_activities_unique_key'
    add_index :activities, [:type_id, :user_id, :notice_id, :reply_id, :advertisement_id], name: 'index_activities_unique_key', unique: true
  end

  def down
    remove_index :activities, name: 'index_activities_unique_key'
    add_index :activities, [:type_id, :user_id, :notice_id, :reply_id], name: 'index_activities_unique_key', unique: true
  end
end
