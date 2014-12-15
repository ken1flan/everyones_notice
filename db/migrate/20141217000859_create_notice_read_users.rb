class CreateNoticeReadUsers < ActiveRecord::Migration
  def change
    create_table :notice_read_users do |t|
      t.references :notice, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
