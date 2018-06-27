class AddPublicTokenToListProxies < ActiveRecord::Migration[4.2]
  def change
    add_column :list_proxies, :public_token, :string, unique: true
  end
end
