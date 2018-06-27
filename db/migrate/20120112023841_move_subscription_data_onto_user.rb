class MoveSubscriptionDataOntoUser < ActiveRecord::Migration[4.2]
  def up
    change_table(:users) do |t|
      t.integer :plan_id
      t.string :stripe_customer_token
      t.date :starts_at
      t.date :ends_at
      t.text :status, default: "inactive"
    end
    drop_table :subscriptions
  end

  def down
    create_table "subscriptions", :force => true do |t|
      t.integer  "plan_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "stripe_customer_token"
      t.date     "starts_at"
      t.date     "ends_at"
      t.text     "status",                :default => "inactive"
    end
    change_table(:users) do |t|
      t.remove :plan_id, :stripe_customer_token, :starts_at, :ends_at, :status
    end
  end
end
