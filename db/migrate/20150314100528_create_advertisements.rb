class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :title, null: false
      t.string :summary, null: false
      t.text :body, null: false
      t.string :image
      t.date :started_on, null: false
      t.date :ended_on, null: false
      t.integer :user_id, null: false

      t.timestamps null: false

      t.index [:started_on, :ended_on]
      t.index [:updated_at]
    end
  end
end
