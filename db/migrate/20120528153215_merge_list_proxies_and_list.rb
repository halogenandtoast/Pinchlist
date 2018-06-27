class MergeListProxiesAndList < ActiveRecord::Migration[4.2]
  def up
    add_column :list_proxies, :title, :string
    update("UPDATE list_proxies set title = lists.title FROM lists WHERE list_proxies.list_id = lists.id")
    remove_column :lists, :title
    rename_table :lists, :list_bases
    rename_table :list_proxies, :lists
    rename_column :users, :list_proxies_count, :lists_count
    rename_column :tasks, :list_id, :list_base_id
    rename_column :lists, :list_id, :list_base_id
  end

  def down
    rename_table :lists, :list_proxies
    rename_table :list_bases, :lists
    add_column :lists, :title, :string
    update("UPDATE lists SET title = list_proxies.title FROM list_proxies WHERE list_proxies.list_id = lists.id")
    remove_column :list_proxies, :title
    rename_column :users, :lists_count, :list_proxies_count
    rename_column :tasks, :list_base_id, :list_id
    rename_column :list_proxies, :list_base_id, :list_id
  end
end
