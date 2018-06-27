class AddListsCountToUsers < ActiveRecord::Migration[4.2]
  class User < ActiveRecord::Base
    has_many :list_proxies
  end
  class ListProxies < ActiveRecord::Base
    belongs_to :user, :counter_cache => true
  end

  def up
    add_column :users, :list_proxies_count, :integer, :default => 0
    User.find_each do |user|
      User.update_counters user.id, :list_proxies_count => user.list_proxies.length
    end
  end

  def down
    remove_column :users, :lists_count
  end
end
