class CreateReopenResponses < ActiveRecord::Migration
  def change
    create_table :reopen_responses do |t|

      t.timestamps
    end
  end
end
