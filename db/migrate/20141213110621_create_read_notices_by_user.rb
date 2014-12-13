class CreateReadNoticesByUser < ActiveRecord::Migration
  def change
    create_table :read_notices_by_users do |t|
      t.references :user, index: true
      t.references :notice, index: true
    end
  end
end
