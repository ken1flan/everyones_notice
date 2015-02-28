class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :user_id, null: false
      t.integer :type, null: false, default: 0
      t.string :url
      t.integer :status, null: false, default: 0

      t.timestamps null: false

      t.index :updated_at
      t.index :user_id
    end
  end
end
