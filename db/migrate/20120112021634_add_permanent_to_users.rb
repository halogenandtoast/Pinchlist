class AddPermanentToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :permanent, :boolean, default: false
  end
end
