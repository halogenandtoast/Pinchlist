class CreateTasks < ActiveRecord::Migration[4.2]
  def self.up
    create_table :tasks do |t|
      t.string :title
      t.references :list

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
