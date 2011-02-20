class CreateListProxiesFromLists < ActiveRecord::Migration
  def self.up
    connection.execute(<<-SQL)
      INSERT INTO list_proxies(list_id, user_id, position, color, created_at, updated_at) SELECT id, user_id, position, color, created_at, updated_at FROM lists;
      ALTER TABLE lists DROP COLUMN position, DROP COLUMN color;
    SQL
  end

  def self.down
  end
end
