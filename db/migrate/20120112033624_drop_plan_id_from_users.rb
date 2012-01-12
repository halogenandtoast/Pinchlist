class DropPlanIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :plan_id
  end

  def down
    add_column :users, :plan_id, :integer
  end
end
