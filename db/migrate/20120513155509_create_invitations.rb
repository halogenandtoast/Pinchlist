class CreateInvitations < ActiveRecord::Migration[4.2]
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :invited_user_id
      t.boolean :paid, default: false
      t.boolean :used_discount, default: false

      t.timestamps
    end

    add_index :invitations, :user_id
    add_index :invitations, :invited_user_id
  end
end
