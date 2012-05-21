class AddPublicTokenToListProxies < ActiveRecord::Migration
  def change
    add_column :list_proxies, :public_token, :string, unique: true
  end
end
