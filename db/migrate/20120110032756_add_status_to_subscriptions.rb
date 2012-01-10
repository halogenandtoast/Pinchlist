class AddStatusToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :status, :text
  end
end
