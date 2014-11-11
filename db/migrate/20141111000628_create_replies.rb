class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :notice_id, null: false
      t.text :body, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :replies, [:notice_id]
    add_index :replies, [:user_id]
  end
end
