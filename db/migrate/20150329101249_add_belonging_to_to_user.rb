class AddBelongingToToUser < ActiveRecord::Migration
  def change
    add_column :users, :belonging_to, :string
  end
end
