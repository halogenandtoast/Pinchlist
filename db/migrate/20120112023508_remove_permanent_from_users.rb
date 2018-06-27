class RemovePermanentFromUsers < ActiveRecord::Migration[4.2]
  def up
    remove_column :users, :permanent
  end

  def down
    add_column :users, :permanent, :boolean, default: false
  end
end
