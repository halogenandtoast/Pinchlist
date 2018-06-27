class AddStartsAtAndEndsAtToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :starts_at, :date
    add_column :subscriptions, :ends_at, :date
  end
end
