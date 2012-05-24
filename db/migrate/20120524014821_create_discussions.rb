class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :category_id
      t.boolean :private, default: false
      t.string :subject
      t.text :message
      t.integer :user_id
      t.integer :reply_count, default: 0
      t.boolean :closed

      t.timestamps
    end
  end
end
