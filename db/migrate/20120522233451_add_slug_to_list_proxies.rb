class AddSlugToListProxies < ActiveRecord::Migration
  def change
    add_column :list_proxies, :slug, :string, null: false, default: "list"
  end
end
