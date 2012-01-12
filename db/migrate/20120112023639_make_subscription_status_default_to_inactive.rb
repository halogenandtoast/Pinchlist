class MakeSubscriptionStatusDefaultToInactive < ActiveRecord::Migration
  def up
    change_column :subscriptions, :status, :text, default: "inactive"
  end

  def down
    change_column :subscriptions, :status, :text
  end
end
