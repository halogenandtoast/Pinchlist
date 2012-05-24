class CreateReplyResponses < ActiveRecord::Migration
  def change
    create_table :reply_responses do |t|
      t.text :message

      t.timestamps
    end
  end
end
