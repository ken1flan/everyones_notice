class CreatePostImages < ActiveRecord::Migration
  def change
    create_table :post_images do |t|
      t.integer :user_id
      t.string :image

      t.timestamps null: false

      t.index :user_id
      t.index :created_at
    end
  end
end
