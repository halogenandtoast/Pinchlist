class CreateLists < ActiveRecord::Migration[4.2]
  def self.up
    create_table :lists do |t|
      t.string :title
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
