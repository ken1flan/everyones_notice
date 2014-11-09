class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title, null: false
      t.text :body
      t.integer :user_id, null: false
      t.datetime :published_at, default: nil
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :notices, [:user_id]
    add_index :notices, [:published_at]
  end
end
