class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :invited_user_id
      t.integer :user_id
      t.integer :amount
      t.timestamps
    end

    add_column :users, :available_credit, :integer, default: 0
    add_index :discounts, :user_id
  end
end
