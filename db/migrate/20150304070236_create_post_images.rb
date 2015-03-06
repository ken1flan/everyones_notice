class CreatePostImages < ActiveRecord::Migration
  def change
    create_table :post_images do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :image, null: false

      t.timestamps null: false

      t.index :user_id
      t.index :created_at
    end
  end
end
