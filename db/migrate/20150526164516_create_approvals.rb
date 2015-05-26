class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.references :approvable, polymorphic: true, index: true
      t.integer :user_id

      t.timestamps null: false

      t.index [:user_id]
    end
  end
end
