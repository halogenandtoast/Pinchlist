class AddSlugToListProxies < ActiveRecord::Migration[4.2]
  def change
    add_column :list_proxies, :slug, :string, null: false, default: "list"
  end
end
