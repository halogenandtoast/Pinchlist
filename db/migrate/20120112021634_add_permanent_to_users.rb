class AddPermanentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permanent, :boolean, default: false
  end
end
