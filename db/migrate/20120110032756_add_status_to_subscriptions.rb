class AddStatusToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :status, :text
  end
end
