class AddNameAndEmailToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :email, :string
  end
end
