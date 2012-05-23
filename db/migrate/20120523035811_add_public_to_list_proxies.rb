class AddPublicToListProxies < ActiveRecord::Migration
  def change
    add_column :list_proxies, :public, :boolean, default: false
  end
end
