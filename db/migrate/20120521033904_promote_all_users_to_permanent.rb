class PromoteAllUsersToPermanent < ActiveRecord::Migration[4.2]
  def up
    update("UPDATE users SET status='permanent'")
  end

  def down
    update("UPDATE users SET status='inactive'")
  end
end
