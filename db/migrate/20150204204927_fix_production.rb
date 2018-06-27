class FixProduction < ActiveRecord::Migration[4.2]
  def change
    unless column_exists? :users, :reset_password_sent_at
      add_column :users, :reset_password_sent_at, :datetime
    end
    unless column_exists? :users, :invitation_created_at
      add_column :users, :invitation_created_at, :datetime
    end
  end
end
