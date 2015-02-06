class CreateNoticeTags < ActiveRecord::Migration
  def change
    create_table :notice_tags do |t|
      t.integer :notice_id
      t.integer :tag_id

      t.timestamps null: false
    end

    add_index :notice_tags, [:notice_id, :tag_id]
    add_index :notice_tags, [:tag_id, :notice_id]
  end
end
