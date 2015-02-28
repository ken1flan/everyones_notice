class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :body, null: false
      t.integer :user_id, null: false
      t.string :url
      t.integer :status, null: false, default: 0

      t.timestamps null: false

      t.index :updated_at
      t.index :user_id
      t.index :status
    end
  end
end
