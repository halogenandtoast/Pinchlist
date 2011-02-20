class CreateListProxies < ActiveRecord::Migration
  def self.up
    create_table :list_proxies do |t|
      t.integer :user_id
      t.integer :list_id
      t.integer :position
      t.string  :color

      t.timestamps
    end
  end

  def self.down
    drop_table :list_proxies
  end
end
