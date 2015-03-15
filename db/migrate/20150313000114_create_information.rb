class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.string :title
      t.string :description
      t.text :body
      t.string :image
      t.integer :user_id
      t.date :started_on
      t.date :ended_on

      t.timestamps null: false

      t.index [:started_on, :ended_on]
    end
  end
end
