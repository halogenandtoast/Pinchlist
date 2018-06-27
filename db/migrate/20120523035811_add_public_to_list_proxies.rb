class AddPublicToListProxies < ActiveRecord::Migration[4.2]
  def change
    add_column :list_proxies, :public, :boolean, default: false
  end
end
