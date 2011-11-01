class AddStartsAtAndEndsAtToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :starts_at, :date
    add_column :subscriptions, :ends_at, :date
  end
end
