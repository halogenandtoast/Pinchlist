class AddEmailToReplyReponses < ActiveRecord::Migration
  def change
    add_column :reply_responses, :email, :string
  end
end
