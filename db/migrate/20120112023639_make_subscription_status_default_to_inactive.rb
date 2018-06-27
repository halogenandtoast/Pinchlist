class MakeSubscriptionStatusDefaultToInactive < ActiveRecord::Migration[4.2]
  def up
    change_column :subscriptions, :status, :text, default: "inactive"
  end

  def down
    change_column :subscriptions, :status, :text
  end
end
