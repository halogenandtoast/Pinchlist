class CreateCloseResponses < ActiveRecord::Migration
  def change
    create_table :close_responses do |t|

      t.timestamps
    end
  end
end
