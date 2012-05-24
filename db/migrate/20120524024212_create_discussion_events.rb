class CreateDiscussionEvents < ActiveRecord::Migration
  def change
    create_table :discussion_events do |t|
      t.string :response_type
      t.integer :response_id
      t.integer :user_id
      t.integer :discussion_id

      t.timestamps
    end

    add_index :discussion_events, :discussion_id
  end
end
