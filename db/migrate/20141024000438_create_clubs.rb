class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name, null:false, limit:128
      t.string :slug, null:false, limit:64
      t.text :description

      t.timestamps
    end
  end
end
