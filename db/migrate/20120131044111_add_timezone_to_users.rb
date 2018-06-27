class AddTimezoneToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :timezone, :string, :default => "America/New_York"
  end
end
